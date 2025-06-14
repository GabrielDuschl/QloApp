<?php
/*
* 2007-2017 PrestaShop
*
* NOTICE OF LICENSE
*
* This source file is subject to the Open Software License (OSL 3.0)
* that is bundled with this package in the file LICENSE.txt.
* It is also available through the world-wide-web at this URL:
* http://opensource.org/licenses/osl-3.0.php
* If you did not receive a copy of the license and are unable to
* obtain it through the world-wide-web, please send an email
* to license@prestashop.com so we can send you a copy immediately.
*
* DISCLAIMER
*
* Do not edit or add to this file if you wish to upgrade PrestaShop to newer
* versions in the future. If you wish to customize PrestaShop for your
* needs please refer to http://www.prestashop.com for more information.
*
*  @author PrestaShop SA <contact@prestashop.com>
*  @copyright  2007-2017 PrestaShop SA
*  @license    http://opensource.org/licenses/osl-3.0.php  Open Software License (OSL 3.0)
*  International Registered Trademark & Property of PrestaShop SA
*/

/**
 * Class ContextCore
 *
 * @since 1.5.0.1
 */
#[\AllowDynamicProperties]
 class ContextCore
{
    /* @var Context */
    protected static $instance;

    /** @var Cart */
    public $cart;

    /** @var Customer */
    public $customer;

    /** @var Cookie */
    public $cookie;

    /** @var Link */
    public $link;

    /** @var Country */
    public $country;

    /** @var Employee */
    public $employee;

    /** @var AdminController|FrontController */
    public $controller;

    /** @var string */
    public $override_controller_name_for_translations;

    /** @var Language */
    public $language;

    /** @var Currency */
    public $currency;

    /** @var AdminTab */
    public $tab;

    /** @var Shop */
    public $shop;

    /** @var Theme */
    public $theme;

    /** @var Smarty */
    public $smarty;

    /** @var Mobile_Detect */
    public $mobile_detect;

    /** @var int */
    public $mode;

    /**
     * Mobile device of the customer
     *
     * @var bool|null
     */
    protected $mobile_device = null;

    /** @var bool|null */
    protected $is_mobile = null;

    /** @var bool|null */
    protected $is_tablet = null;

    /** @var int */
    const DEVICE_COMPUTER = 1;

    /** @var int */
    const DEVICE_TABLET = 2;

    /** @var int */
    const DEVICE_MOBILE = 4;

    /** @var int */
    const MODE_STD = 1;

    /** @var int */
    const MODE_STD_CONTRIB = 2;

    /** @var int */
    const MODE_HOST_CONTRIB = 4;

    /** @var int */
    const MODE_HOST = 8;

    /**
     * Sets Mobile_Detect tool object
     *
     * @return Mobile_Detect
     */
    public function getMobileDetect()
    {
        if ($this->mobile_detect === null) {
            require_once(_PS_TOOL_DIR_.'mobile_detect/autoload.php');
            $this->mobile_detect = new Detection\MobileDetect();
        }
        return $this->mobile_detect;
    }

    /**
     * Checks if visitor's device is a mobile device
     *
     * @return bool
     */
    public function isMobile()
    {
        if ($this->is_mobile === null) {
            $mobile_detect = $this->getMobileDetect();
            $this->is_mobile = $mobile_detect->isMobile();
        }
        return $this->is_mobile;
    }

    /**
     * Checks if visitor's device is a tablet device
     *
     * @return bool
     */
    public function isTablet()
    {
        if ($this->is_tablet === null) {
            $mobile_detect = $this->getMobileDetect();
            $this->is_tablet = $mobile_detect->isTablet();
        }
        return $this->is_tablet;
    }

    /**
     * Sets mobile_device context variable
     *
     * @return bool
     */
    public function getMobileDevice()
    {
        if ($this->mobile_device === null) {
            $this->mobile_device = false;
            if ($this->checkMobileContext()) {
                if (isset(Context::getContext()->cookie->no_mobile) && Context::getContext()->cookie->no_mobile == false && (int)Configuration::get('PS_ALLOW_MOBILE_DEVICE') != 0) {
                    $this->mobile_device = true;
                } else {
                    switch ((int)Configuration::get('PS_ALLOW_MOBILE_DEVICE')) {
                        case 1: // Only for mobile device
                            if ($this->isMobile() && !$this->isTablet()) {
                                $this->mobile_device = true;
                            }
                            break;
                        case 2: // Only for touchpads
                            if ($this->isTablet() && !$this->isMobile()) {
                                $this->mobile_device = true;
                            }
                            break;
                        case 3: // For touchpad or mobile devices
                            if ($this->isMobile() || $this->isTablet()) {
                                $this->mobile_device = true;
                            }
                            break;
                    }
                }
            }
        }
        return $this->mobile_device;
    }

    /**
     * Returns mobile device type
     *
     * @return int
     */
    public function getDevice()
    {
        static $device = null;

        if ($device === null) {
            if ($this->isTablet()) {
                $device = Context::DEVICE_TABLET;
            } elseif ($this->isMobile()) {
                $device = Context::DEVICE_MOBILE;
            } else {
                $device = Context::DEVICE_COMPUTER;
            }
        }

        return $device;
    }

    /**
     * Checks if mobile context is possible
     *
     * @return bool
     * @throws PrestaShopException
     */
    protected function checkMobileContext()
    {
        // Check mobile context
        if (Tools::isSubmit('no_mobile_theme')) {
            Context::getContext()->cookie->no_mobile = true;
            if (Context::getContext()->cookie->id_guest) {
                $guest = new Guest(Context::getContext()->cookie->id_guest);
                $guest->mobile_theme = false;
                $guest->update();
            }
        } elseif (Tools::isSubmit('mobile_theme_ok')) {
            Context::getContext()->cookie->no_mobile = false;
            if (Context::getContext()->cookie->id_guest) {
                $guest = new Guest(Context::getContext()->cookie->id_guest);
                $guest->mobile_theme = true;
                $guest->update();
            }
        }

        return isset($_SERVER['HTTP_USER_AGENT'])
            && isset(Context::getContext()->cookie)
            && (bool)Configuration::get('PS_ALLOW_MOBILE_DEVICE')
            && @filemtime(_PS_THEME_MOBILE_DIR_)
            && !Context::getContext()->cookie->no_mobile;
    }

    /**
     * Get a singleton instance of Context object
     *
     * @return Context
     */
    public static function getContext()
    {
        if (!isset(self::$instance)) {
            self::$instance = new Context();
        }

        return self::$instance;
    }

    /**
     * @param $test_instance Context
     * Unit testing purpose only
     */
    public static function setInstanceForTesting($test_instance)
    {
        self::$instance = $test_instance;
    }

    /**
     * Unit testing purpose only
     */
    public static function deleteTestingInstance()
    {
        self::$instance = null;
    }

    /**
     * Clone current context object
     *
     * @return Context
     */
    public function cloneContext()
    {
        return clone($this);
    }

    public function updateCustomer(Customer $customer, $loginCustomer = 0)
    {
        $this->customer = $customer;
        $this->cookie->id_customer = (int) $customer->id;
        $this->cookie->customer_lastname = $customer->lastname;
        $this->cookie->customer_firstname = $customer->firstname;
        $this->cookie->passwd = $customer->passwd;
        $this->cookie->logged = true;
        $customer->logged = true;
        $this->cookie->email = $customer->email;
        $this->cookie->is_guest = $customer->isGuest();

        $currentCookieGuest = $this->cookie->id_guest;

        if (Configuration::get('PS_CART_FOLLOWING') && (empty($this->cookie->id_cart) || Cart::getNbProducts((int) $this->cookie->id_cart) == 0) && $idCart = (int) Cart::lastNoneOrderedCart($this->customer->id)) {
            $this->cart = new Cart($idCart);
            $this->cart->secure_key = $customer->secure_key;
            if (!$loginCustomer) {
                $this->cookie->id_guest = (int) $this->cart->id_guest;
            }
        } else {
            if (!isset($this->cookie->id_guest)) {
                Guest::setNewGuest($this->cookie);
            }

            if (Validate::isLoadedObject($this->cart)) {
                $idCarrier = (int) $this->cart->id_carrier;
                $this->cart->secure_key = $customer->secure_key;
                $this->cart->id_guest = (int) $this->cookie->id_guest;
                $this->cart->id_carrier = 0;
                if (!empty($idCarrier)) {
                    $deliveryOption = [$this->cart->id_address_delivery => $idCarrier . ','];
                    $this->cart->setDeliveryOption($deliveryOption);
                } else {
                    $this->cart->setDeliveryOption(null);
                }
                $this->cart->id_customer = (int) $customer->id;
                $this->cart->id_address_invoice = (int) Address::getFirstCustomerAddressId((int) ($customer->id));

                // update id guest in htl_cart_booking_data for bookings added to the cart as a visitor
                $objCartBookingData = new HotelCartBookingData();
                if ($hotelCartBookings = $objCartBookingData->getCartCurrentDataByCartId($this->cart->id)) {
                    foreach ($hotelCartBookings as $cartBooking) {
                        $objCartBookingData = new HotelCartBookingData($cartBooking['id']);
                        $objCartBookingData->id_guest = (int) $this->cookie->id_guest;
                        $objCartBookingData->id_customer = (int) $customer->id;
                        $objCartBookingData->save();
                    }
                }
            }
        }
        if (Validate::isLoadedObject($this->cart)) {
            $this->cart->save();
            $this->cart->autosetProductAddress();

            $this->cookie->id_cart = (int) $this->cart->id;
        }

        // if customer is login to account
        if ($loginCustomer) {
            // Update or merge the guest with the customer id (login and account creation)
            $objGuest = new Guest($currentCookieGuest);
            if ($customerGuestId = Guest::getFromCustomer((int)$this->cookie->id_customer)) {
                if ($objGuest->id != $customerGuestId) {
                    // The new guest is merged with the old one when it's connecting to an account
                    $objGuest->mergeWithCustomer($customerGuestId, $this->cookie->id_customer);

                    // update the id_guest in the cookie
                    $this->cookie->id_guest = $customerGuestId;
                }
            } else {
                $objGuest->id_customer = (int)$this->cookie->id_customer;
                $objGuest->update();
            }
        }

        $this->cookie->write();
    }
}
