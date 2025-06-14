{*
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
*}

<div class="panel">
	<div class="panel-heading">
		{if isset($edit)}
			<i class='icon-pencil'></i>&nbsp{l s='Edit Advanced Price Rule' mod='hotelreservationsystem'}
		{else}
			<i class='icon-plus'></i>&nbsp{l s='Add New Advanced Price Rule' mod='hotelreservationsystem'}
		{/if}
	</div>
	<form id="{$table}_form" class="defaultForm form-horizontal" action="{$current}&{if !empty($submit_action)}{$submit_action}{/if}&token={$token}" method="post" enctype="multipart/form-data" {if isset($style)}style="{$style}"{/if}>
		{if isset($edit)}
			<input type="hidden" value="{$objFeaturePrice->id|escape:'html':'UTF-8'}" name="id_feature_price" />
		{/if}

		<div class="form-group">
			<label class="col-sm-3 control-label required" for="feature_price_name" >
				{l s='Advanced Price Rule Name ' mod='hotelreservationsystem'}
			</label>
			<div class="col-lg-3">
				{foreach from=$languages item=language}
					{assign var="feature_price_name" value="feature_price_name_`$language.id_lang`"}
					<input type="text" id="{$feature_price_name}" name="{$feature_price_name}" value="{if isset($objFeaturePrice->feature_price_name[$language.id_lang]) && $objFeaturePrice->feature_price_name[$language.id_lang]}{$objFeaturePrice->feature_price_name[$language.id_lang]}{else if isset($smarty.post.$feature_price_name)}{$smarty.post.$feature_price_name}{/if}" data-lang-name="{$language.name}" placeholder="{l s='Enter advanced price rule name' mod='hotelreservationsystem'}" class="form-control feature_price_name_all" {if $currentLang.id_lang != $language.id_lang}style="display:none;"{/if}/>
				{/foreach}
			</div>
			{if $languages|@count > 1}
				<div class="col-lg-2">
					<button type="button" id="feature_price_rule_lang_btn" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
						{$currentLang.iso_code}
						<span class="caret"></span>
					</button>
					<ul class="dropdown-menu">
						{foreach from=$languages item=language}
							<li>
								<a href="javascript:void(0)" onclick="showFeaturePriceRuleLangField('{$language.iso_code}', {$language.id_lang});">{$language.name}</a>
							</li>
						{/foreach}
					</ul>
				</div>
			{/if}
			<div class="col-lg-9 col-lg-offset-3">
				<div class="help-block">
					{l s='Use {room_type_name} to generate dynamic feature price names.' mod='hotelreservationsystem'}
				</div>
			</div>
		</div>

		{if !isset($objFeaturePrice) || !$objFeaturePrice->id}
			<div class="form-group">
				<label class="control-label col-lg-3">
					<span class="label-tooltip" data-toggle="tooltip" data-html="true" title="" data-original-title="{l s='Enable this option to create advance price rules for multiple room types.' mod='hotelreservationsystem'}">
						{l s='Create for multiple room types' mod='hotelreservationsystem'}
					</span>
				</label>
				<div class="col-lg-9 ">
					<span class="switch prestashop-switch fixed-width-lg">
						<input type="radio" {if isset($smarty.post.create_multiple) && $smarty.post.create_multiple == 1}checked="checked" {/if} value="1" id="create_multiple_on" name="create_multiple">
						<label for="create_multiple_on">{l s='Yes' mod='hotelreservationsystem'}</label>
						<input {if !isset($smarty.post.create_multiple) || isset($smarty.post.create_multiple) && $smarty.post.create_multiple == 0} checked="checked" {/if} type="radio" value="0" id="create_multiple_off" name="create_multiple">
						<label for="create_multiple_off">{l s='No' mod='hotelreservationsystem'}</label>
						<a class="slide-button btn"></a>
					</span>
				</div>
			</div>
			{if isset($hotel_tree)}
				<div class="form-group room-type-name-tree" style="display:none;">
					<label class="col-sm-3 control-label required" for="feature_price_name" >
						<span class="label-tooltip" data-toggle="tooltip" data-html="true" title="" data-original-title="{l s='Select the room types for which you are going to create this advanced price rule.' mod='hotelreservationsystem'}">
							{l s='Room Types' mod='hotelreservationsystem'}
						</span>
					</label>
					<div class="col-sm-7">
						{$hotel_tree}
					</div>
				</div>
			{/if}
		{/if}

		<div class="form-group room-type-name">
			<label class="col-sm-3 control-label required" for="feature_price_name" >
				{l s='Room Type' mod='hotelreservationsystem'}
			</label>
			<div class="col-sm-3">
				<input autocomplete="off" type="text" id="room_type_name" name="room_type_name" class="form-control" placeholder= "{l s='Enter room type name' mod='hotelreservationsystem'}" value="{if isset($productName)}{$productName}{/if}"/>
				<input type="hidden" id="room_type_id" name="room_type_id" class="form-control" value="{if isset($objFeaturePrice->id_product)}{$objFeaturePrice->id_product}{else}0{/if}"/>
				<div class="dropdown">
					<ul class="room_type_search_results_ul"></ul>
				</div>
				<p class="error-block" style="display:none; color: #CD5D5D;">{l s='No match found for this search. Please try with an existing name.' mod='hotelreservationsystem'}</p>
			</div>
			<div class="col-lg-9 col-lg-offset-3">
				<div class="help-block">
					{l s='Enter room type name and select the room for which you are going to create this advanced price rule.' mod='hotelreservationsystem'}
				</div>
			</div>
		</div>

		<div class="form-group">
            <label for="date_selection_type" class="control-label col-lg-3">
              {l s='Date Selection type' mod='hotelreservationsystem'}
            </label>
            <div class="col-lg-3">
				<select class="form-control" name="date_selection_type" id="date_selection_type">
					<option value="{HotelRoomTypeFeaturePricing::DATE_SELECTION_TYPE_RANGE}" {if (isset($smarty.post.date_selection_type) && $smarty.post.date_selection_type == HotelRoomTypeFeaturePricing::DATE_SELECTION_TYPE_RANGE) || (isset($objFeaturePrice->date_selection_type) && $objFeaturePrice->date_selection_type == HotelRoomTypeFeaturePricing::DATE_SELECTION_TYPE_RANGE)}selected = "selected"{/if}>
					  {l s='Date Range' mod='hotelreservationsystem'}
					</option>
					<option value="{HotelRoomTypeFeaturePricing::DATE_SELECTION_TYPE_SPECIFIC}" {if (isset($smarty.post.date_selection_type) && $smarty.post.date_selection_type == HotelRoomTypeFeaturePricing::DATE_SELECTION_TYPE_SPECIFIC) || (isset($objFeaturePrice->date_selection_type) && $objFeaturePrice->date_selection_type == HotelRoomTypeFeaturePricing::DATE_SELECTION_TYPE_SPECIFIC)}selected = "selected"{/if}>
					  {l s='Specific Date' mod='hotelreservationsystem'}
					</option>
				</select>
			</div>
		</div>

		<div class="form-group specific_date_type" {if (isset($smarty.post.date_selection_type) && $smarty.post.date_selection_type != HotelRoomTypeFeaturePricing::DATE_SELECTION_TYPE_SPECIFIC) || (isset($objFeaturePrice->date_selection_type) && $objFeaturePrice->date_selection_type != HotelRoomTypeFeaturePricing::DATE_SELECTION_TYPE_SPECIFIC)}style="display:none;"{else if !isset($edit) && !isset($smarty.post.date_selection_type)}style="display:none;"{/if}>
			<label class="col-sm-3 control-label required" for="specific_date" >
				{l s='Specific Date' mod='hotelreservationsystem'}
			</label>
			<div class="col-sm-3">
				<input type="text" id="specific_date" name="specific_date" class="form-control datepicker-input" value="{if isset($objFeaturePrice->date_from)}{$objFeaturePrice->date_from}{else}{$date_from}{/if}" readonly/>
			</div>
		</div>

		<div class="form-group date_range_type" {if (isset($objFeaturePrice->date_selection_type) && $objFeaturePrice->date_selection_type == HotelRoomTypeFeaturePricing::DATE_SELECTION_TYPE_SPECIFIC) || (isset($smarty.post.date_selection_type) && $smarty.post.date_selection_type != HotelRoomTypeFeaturePricing::DATE_SELECTION_TYPE_RANGE)}style="display:none;"{/if}>
			<label class="col-sm-3 control-label required" for="date_form" >
				{l s='Date From' mod='hotelreservationsystem'}
			</label>
			<div class="col-sm-3">
				<input type="text" id="feature_plan_date_from" name="date_from" class="form-control datepicker-input" value="{if isset($smarty.post.date_from) && $smarty.post.date_from}{$smarty.post.date_from}{elseif isset($objFeaturePrice->date_from)}{$objFeaturePrice->date_from|date_format:'%d-%m-%Y'}{else}{$date_from|date_format:'%d-%m-%Y'}{/if}" readonly/>
			</div>
		</div>
		<div class="form-group date_range_type" {if (isset($objFeaturePrice->date_selection_type) && $objFeaturePrice->date_selection_type == HotelRoomTypeFeaturePricing::DATE_SELECTION_TYPE_SPECIFIC) || (isset($smarty.post.date_selection_type) && $smarty.post.date_selection_type != HotelRoomTypeFeaturePricing::DATE_SELECTION_TYPE_RANGE)}style="display:none;"{/if}>
			<label class="col-sm-3 control-label required" for="date_to" >
				{l s='Date To' mod='hotelreservationsystem'}
			</label>
			<div class="col-sm-3">
				<input type="text" id="feature_plan_date_to" name="date_to" class="form-control datepicker-input" value="{if isset($smarty.post.date_to) && $smarty.post.date_to}{$smarty.post.date_to}{elseif isset($objFeaturePrice->date_to)}{$objFeaturePrice->date_to|date_format:'%d-%m-%Y'}{else}{$date_to|date_format:'%d-%m-%Y'}{/if}" readonly/>
			</div>
		</div>

		<div class="form-group special_days_content" {if (isset($objFeaturePrice->date_selection_type) && $objFeaturePrice->date_selection_type == HotelRoomTypeFeaturePricing::DATE_SELECTION_TYPE_SPECIFIC) || (isset($smarty.post.date_selection_type) && $smarty.post.date_selection_type != HotelRoomTypeFeaturePricing::DATE_SELECTION_TYPE_RANGE)}style="display:none;"{/if}>
			<label class="control-label col-lg-3">
				<span class="label-tooltip" data-toggle="tooltip" data-html="true" title="" data-original-title="{l s='Enable this option to restrict this rule to specific week days (for example, weekends) of the selected date range. If disabled, rule will be applicable to all week days.' mod='hotelreservationsystem'}">
					{l s='Restrict to Week Days' mod='hotelreservationsystem'}
				</span>
			</label>
			<div class="col-lg-9 ">
				<span class="switch prestashop-switch fixed-width-lg">
					<input type="radio" {if isset($smarty.post.is_special_days_exists) && $smarty.post.is_special_days_exists == 1}checked="checked"{elseif isset($edit) && $objFeaturePrice->is_special_days_exists == 1}checked="checked"{/if} value="1" id="is_special_days_exists_on" name="is_special_days_exists">
					<label for="is_special_days_exists_on">{l s='Yes' mod='hotelreservationsystem'}</label>
					<input {if isset($smarty.post.is_special_days_exists) && $smarty.post.is_special_days_exists == 0} checked="checked" {elseif (isset($edit) && $objFeaturePrice->is_special_days_exists == 0) || !isset($edit)} checked="checked"{/if} type="radio" value="0" id="is_special_days_exists_off" name="is_special_days_exists">
					<label for="is_special_days_exists_off">{l s='No' mod='hotelreservationsystem'}</label>
					<a class="slide-button btn"></a>
				</span>
			</div>
		</div>

		<div class="form-group week_days" {if (isset($smarty.post.is_special_days_exists) && $smarty.post.is_special_days_exists) 	|| (isset($objFeaturePrice->is_special_days_exists) && $objFeaturePrice->is_special_days_exists)}style="display:block;"{/if}>
			<label for="special_days" class="control-label col-lg-3">
				{l s='Select Week Days' mod='hotelreservationsystem'}
			</label>
			<div class="col-lg-3 checkboxes-wrap">
				<div class="day-wrap">
					<input type="checkbox" name="special_days[]" value="mon"
					{if (isset($smarty.post.special_days) && in_array('mon', $smarty.post.special_days))
						|| (isset($special_days) && $special_days && in_array('mon', $special_days))}
						checked="checked"
					{/if}/>
					<p>{l s='Mon' mod='hotelreservationsystem'}</p>
				</div>
				<div class="day-wrap">
					<input type="checkbox" name="special_days[]" value="tue"
					{if (isset($smarty.post.special_days) && in_array('tue', $smarty.post.special_days))
						|| (isset($special_days) && $special_days && in_array('tue', $special_days))}
						checked="checked"
					{/if}/>
					<p>{l s='Tue' mod='hotelreservationsystem'}</p>
				</div>
				<div class="day-wrap">
					<input type="checkbox" name="special_days[]" value="wed"
					{if (isset($smarty.post.special_days) && in_array('wed', $smarty.post.special_days))
						|| (isset($special_days) && $special_days && in_array('wed', $special_days))}
						checked="checked"
					{/if}/>
					<p>{l s='Wed' mod='hotelreservationsystem'}</p>
				</div>
				<div class="day-wrap">
					<input type="checkbox" name="special_days[]" value="thu"
					{if (isset($smarty.post.special_days) && in_array('thu', $smarty.post.special_days))
						|| (isset($special_days) && $special_days && in_array('thu', $special_days))}
						checked="checked"
					{/if}/>
					<p>{l s='Thu' mod='hotelreservationsystem'}</p>
				</div>
				<div class="day-wrap">
					<input type="checkbox" name="special_days[]" value="fri"
					{if (isset($smarty.post.special_days) && in_array('fri', $smarty.post.special_days))
						|| (isset($special_days) && $special_days && in_array('fri', $special_days))}
						checked="checked"
					{/if}/>
					<p>{l s='Fri' mod='hotelreservationsystem'}</p>
				</div>
				<div class="day-wrap">
					<input type="checkbox" name="special_days[]" value="sat"
					{if (isset($smarty.post.special_days) && in_array('sat', $smarty.post.special_days))
						|| (isset($special_days) && $special_days && in_array('sat', $special_days))}
						checked="checked"
					{/if}/>
					<p>{l s='Sat' mod='hotelreservationsystem'}</p>
				</div>
				<div class="day-wrap">
					<input type="checkbox" name="special_days[]" value="sun"
					{if (isset($smarty.post.special_days) && in_array('sun', $smarty.post.special_days))
						|| (isset($special_days) && $special_days && in_array('sun', $special_days))}
						checked="checked"
					{/if}/>
					<p>{l s='Sun' mod='hotelreservationsystem'}</p>
				</div>
			</div>
		</div>

		<div class="form-group">
            <label for="Price Impact Way" class="control-label col-lg-3">
              {l s='Impact Way' mod='hotelreservationsystem'}
            </label>
            <div class="col-lg-3">
				<select class="form-control" name="price_impact_way" id="price_impact_way">
					<option value="{HotelRoomTypeFeaturePricing::IMPACT_WAY_DECREASE}" {if (isset($smarty.post.price_impact_way) && $smarty.post.price_impact_way == HotelRoomTypeFeaturePricing::IMPACT_WAY_DECREASE) || (isset($objFeaturePrice->impact_way) && $objFeaturePrice->impact_way == HotelRoomTypeFeaturePricing::IMPACT_WAY_DECREASE && !isset($smarty.post.price_impact_way))}selected = "selected"{/if}>
					  {l s='Decrease Price' mod='hotelreservationsystem'}
					</option>
					<option value="{HotelRoomTypeFeaturePricing::IMPACT_WAY_INCREASE}" {if (isset($smarty.post.price_impact_way) && $smarty.post.price_impact_way == HotelRoomTypeFeaturePricing::IMPACT_WAY_INCREASE) || (isset($objFeaturePrice->impact_way) && $objFeaturePrice->impact_way == HotelRoomTypeFeaturePricing::IMPACT_WAY_INCREASE && !isset($smarty.post.price_impact_way))}selected = "selected"{/if}>
					  {l s='Increase Price' mod='hotelreservationsystem'}
					</option>
					<option value="{HotelRoomTypeFeaturePricing::IMPACT_WAY_FIX_PRICE}" {if (isset($smarty.post.price_impact_way) && $smarty.post.price_impact_way == HotelRoomTypeFeaturePricing::IMPACT_WAY_FIX_PRICE) || (isset($objFeaturePrice->impact_way) && $objFeaturePrice->impact_way == HotelRoomTypeFeaturePricing::IMPACT_WAY_FIX_PRICE && !isset($smarty.post.price_impact_way))}selected = "selected"{/if}>
						{l s='Fixed Price' mod='hotelreservationsystem'}
					</option>
				</select>
			</div>
		</div>

		<div class="form-group">
            <label for="Price Impact Type" class="control-label col-lg-3">
              {l s='Impact Type' mod='hotelreservationsystem'}
            </label>
            <div class="col-lg-3">
				<select class="form-control" name="price_impact_type" id="price_impact_type" {if (isset($smarty.post.price_impact_way) && $smarty.post.price_impact_way == HotelRoomTypeFeaturePricing::IMPACT_WAY_FIX_PRICE) || (isset($objFeaturePrice->impact_way) && $objFeaturePrice->impact_way == HotelRoomTypeFeaturePricing::IMPACT_WAY_FIX_PRICE && !isset($smarty.post.price_impact_way))}disabled="disabled"{/if}>
					<option value="{HotelRoomTypeFeaturePricing::IMPACT_TYPE_PERCENTAGE}" {if (isset($smarty.post.price_impact_type) && $smarty.post.price_impact_type == HotelRoomTypeFeaturePricing::IMPACT_TYPE_PERCENTAGE) || (isset($objFeaturePrice->impact_type) && $objFeaturePrice->impact_type == HotelRoomTypeFeaturePricing::IMPACT_TYPE_PERCENTAGE && !isset($smarty.post.price_impact_type))}selected = "selected"{/if}>
					  {l s='Percentage' mod='hotelreservationsystem'}
					</option>
					<option value="{HotelRoomTypeFeaturePricing::IMPACT_TYPE_FIXED_PRICE}" {if (isset($smarty.post.price_impact_way) && $smarty.post.price_impact_way == HotelRoomTypeFeaturePricing::IMPACT_WAY_FIX_PRICE) || (isset($objFeaturePrice->impact_way) && $objFeaturePrice->impact_way == HotelRoomTypeFeaturePricing::IMPACT_WAY_FIX_PRICE && !isset($smarty.post.price_impact_way)) || (isset($smarty.post.price_impact_type) && $smarty.post.price_impact_type == HotelRoomTypeFeaturePricing::IMPACT_TYPE_FIXED_PRICE) || (isset($objFeaturePrice->impact_type) && $objFeaturePrice->impact_type == HotelRoomTypeFeaturePricing::IMPACT_TYPE_FIXED_PRICE && !isset($smarty.post.price_impact_type))}selected = "selected"{/if}>
					  {l s='Amount' mod='hotelreservationsystem'}
					</option>
				</select>
			</div>
		</div>

		<div class="form-group">
			<label class="col-sm-3 control-label required" for="feature_price_name" >
				{l s='Impact Value' mod='hotelreservationsystem'}({l s='tax excl.' mod='hotelreservationsystem'})
			</label>
			<div class="col-lg-3">
				<div class="input-group">
					<span class="input-group-addon payment_type_icon">{if isset($edit)} {if $objFeaturePrice->impact_type == HotelRoomTypeFeaturePricing::IMPACT_TYPE_FIXED_PRICE}{$defaultcurrency_sign}{else}%{/if}{else}%{/if}</span>
					<input type="text" id="impact_value" name="impact_value"
					value="{if isset($smarty.post.impact_value) && $smarty.post.impact_value}{$smarty.post.impact_value}{elseif isset($objFeaturePrice->impact_value)}{$objFeaturePrice->impact_value}{/if}"/>
				</div>
			</div>
		</div>

		<div class="form-group">
			<label class="control-label col-lg-3">
				<span>
					{l s='Enable Advanced Price Rule' mod='hotelreservationsystem'}
				</span>
			</label>
			<div class="col-lg-9 ">
				<span class="switch prestashop-switch fixed-width-lg">
					<input type="radio" {if isset($edit) && $objFeaturePrice->active==1} checked="checked" {else}checked="checked"{/if} value="1" id="enable_feature_price_on" name="enable_feature_price">
					<label for="enable_feature_price_on">{l s='Yes' mod='hotelreservationsystem'}</label>
					<input {if isset($edit) && $objFeaturePrice->active==0} checked="checked" {/if} type="radio" value="0" id="enable_feature_price_off" name="enable_feature_price">
					<label for="enable_feature_price_off">{l s='No' mod='hotelreservationsystem'}</label>
					<a class="slide-button btn"></a>
				</span>
			</div>
		</div>

		{* select group accesses *}
		<div class="form-group">
			<label class="control-label required col-lg-3">
				<span class="label-tooltip required" data-toggle="tooltip" data-html="true" data-original-title="{l s='Select all the groups that you would like to apply to this advanced price rule.' mod='hotelreservationsystem'}">{l s='Group access' mod='hotelreservationsystem'}</span>
			</label>
			<div class="col-lg-6">
				<div class="table-responsive">
					<table class="table table-bordered">
						<thead>
							<tr>
								<th class="text-center"></th>
								<th class="text-center">{l s='Group' mod='hotelreservationsystem'}</th>
							</tr>
						</thead>
						<tbody>
							{if isset($groups) && $groups}
								{foreach $groups as $group}
									<tr>
										<td class="text-center">
											<input type="checkbox" name="groupBox[]" value="{$group['id_group']|escape:'html':'UTF-8'}"
												{if isset($feature_price_groups) && $feature_price_groups && $group['id_group']|in_array:$feature_price_groups}
													checked
												{elseif empty($objFeaturePrice->id)}
													checked
												{/if}
											/>
										</td>
										<td class="text-center">{$group['name']|escape:'html':'UTF-8'}</td>
									</tr>
								{/foreach}
							{else}
								<tr>
									<td class="list-empty" colspan="2">
										<div class="list-empty-msg">
											<i class="icon-warning-sign list-empty-icon"></i>
											{l s='No Groups Available' mod='hotelreservationsystem'}
										</div>
									</td>
								</tr>
							{/if}
						</tbody>
					</table>
				</div>
			</div>
		</div>

		<div class="panel-footer">
			<a href="{$link->getAdminLink('AdminHotelFeaturePricesSettings')|escape:'html':'UTF-8'}" class="btn btn-default">
				<i class="process-icon-cancel"></i>{l s='Cancel' mod='hotelreservationsystem'}
			</a>
			<button type="submit" name="submitAdd{$table|escape:'html':'UTF-8'}" class="btn btn-default pull-right">
				<i class="process-icon-save"></i> {l s='Save' mod='hotelreservationsystem'}
			</button>
			<button type="submit" name="submitAdd{$table|escape:'html':'UTF-8'}AndStay" class="btn btn-default pull-right">
				<i class="process-icon-save"></i> {l s='Save and stay' mod='hotelreservationsystem'}
			</button>
		</div>
	</form>
</div>

{strip}
	{addJsDef autocomplete_room_search_url = $link->getAdminLink('AdminHotelFeaturePricesSettings')}
	{addJsDef defaultcurrency_sign = $defaultcurrency_sign mod='hotelreservationsystem'}
	{addJsDef booking_date_from = $date_from mod='hotelreservationsystem'}
{/strip}

{block name=script}
	<script type="text/javascript">
		var id_language = {$defaultFormLanguage|intval};
		allowEmployeeFormLang = {$allowEmployeeFormLang|intval};
	</script>
{/block}
