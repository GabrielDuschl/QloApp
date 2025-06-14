<?php
/**
* 2010-2020 Webkul.
*
* NOTICE OF LICENSE
*
* All right is reserved,
* Please go through this link for complete license : https://store.webkul.com/license.html
*
* DISCLAIMER
*
* Do not edit or add to this file if you wish to upgrade this module to newer
* versions in the future. If you wish to customize this module for your
* needs please refer to https://store.webkul.com/customisation-guidelines/ for more information.
*
*  @author    Webkul IN <support@webkul.com>
*  @copyright 2010-2020 Webkul IN
*  @license   https://store.webkul.com/license.html
*/

class OrderReturnDetailCore extends ObjectModel
{
    /** @var int */
    public $id_order_return;

    /** @var int */
    public $id_htl_booking;

    /** @var int */
    public $id_service_product_order_detail;

    /** @var float amount of the refund transaction */
    public $refunded_amount;

    public $id_order_detail;

    // Used to manage refunded or refunde denied bookings in a refund request : 1 for only refunded request completed and refunded bookings
    public $id_customization;
    public $product_quantity;

    const REFUND_REQUEST_STATUS_LATEST = 1;
    const REFUND_REQUEST_STATUS_PENDING = 2;
    const REFUND_REQUEST_STATUS_COMPLETED = 3;

    /**
     * @see ObjectModel::$definition
     */
    public static $definition = array(
        'table' => 'order_return_detail',
        'primary' => 'id_order_return_detail',
        'fields' => array(
            'id_order_return' => array('type' => self::TYPE_INT, 'validate' => 'isUnsignedId', 'required' => true),
            'id_htl_booking' => array('type' => self::TYPE_INT, 'validate' => 'isUnsignedId'),
            'id_service_product_order_detail' => array('type' => self::TYPE_INT, 'validate' => 'isUnsignedId'),
            'id_order_detail' => array('type' => self::TYPE_INT, 'validate' => 'isUnsignedId', 'default' => 0),
            'id_customization' => array('type' => self::TYPE_INT, 'validate' => 'isUnsignedId', 'default' => 0),
            'product_quantity' => array('type' => self::TYPE_INT, 'validate' => 'isUnsignedId', 'default' => 0),
            'refunded_amount' => array('type' => self::TYPE_FLOAT),
        ),
    );

    public static function getReturnDetailByIdBookingDetail($idHtlBooking)
    {
        $idOrderReturnDetail = Db::getInstance()->getValue('
            SELECT `id_order_return_detail` FROM `'._DB_PREFIX_.'order_return_detail` ord
            WHERE `id_htl_booking` = '.(int)$idHtlBooking
        );

        if ($idOrderReturnDetail) {
            return new OrderReturnDetail($idOrderReturnDetail);
        }
        return null;
    }

    public static function deleteReturnDetailByIdBookingDetail($idOrder, $idHtlBooking)
    {
        if (Validate::isLoadedObject($objOrderReturnDetail = OrderReturnDetail::getReturnDetailByIdBookingDetail($idHtlBooking))) {
            if ($objOrderReturnDetail->delete()) {
                $objOrderReturn = new OrderReturn();
                if (empty($objOrderReturn->getOrderRefundRequestedBookings($idOrder, $objOrderReturnDetail->id_order_return, true))) {
                    $objOrderReturn = new OrderReturn($objOrderReturnDetail->id_order_return);
                    $objOrderReturn->delete();
                }
            }
        }
    }
}
