		<form action="ajouter_contribution.php" method="post">
{if $error_detected|@count != 0}
		<div id="errorbox">
			<h1>{_T string="- ERROR -"}</h1>
			<ul>
{foreach from=$error_detected item=error}
				<li>{$error}</li>
{/foreach}
			</ul>
		</div>
{/if}
{if $warning_detected|@count != 0}
		<div id="warningbox">
			<h1>{_T string="- WARNING -"}</h1>
			<ul>
    {foreach from=$warning_detected item=warning}
                <li>{$warning}</li>
    {/foreach}
			</ul>
		</div>
{/if}
{if !$head_redirect}
		<div class="bigtable">
    {if $contribution->isTransactionPart()}
        {assign var="mid" value=$contribution->transaction->member}
            <table id="transaction_detail">
                <caption>{_T string="Related transaction informations"}</caption>
                <tr>
                    <th class="listing">#</th>
                    <th class="listing">{_T string="Date"}</th>
                    <th class="listing">{_T string="Member"}</th>
                    <th class="listing">{_T string="Amount"}</th>
                    <th class="listing">{_T string="Not dispatched amount"}</th>
                </tr>
                <tr>
                    <td>{$contribution->transaction->id}</td>
                    <td>{$contribution->transaction->date}</td>
                    <td>{memberName id="$mid"}</td>
                    <td class="right">{$contribution->transaction->amount}</td>
                    <td class="right">{$contribution->transaction->getMissingAmount()}</td>
                </tr>
            </table>
    {/if}
			<fieldset class="cssform">
				<legend class="ui-state-active ui-corner-top">{_T string="Select contributor and contribution type"}</legend>
				<p>
					<label for="id_adh" class="bline">{_T string="Contributor:"}</label>
					<select name="id_adh" id="id_adh"{$disabled.id_adh}>
						{if $adh_selected eq 0}
						<option value="">{_T string="-- select a name --"}</option>
						{/if}
						{html_options options=$adh_options selected=$contribution->member}
					</select>
				</p>
				<p>
					<label for="id_type_cotis" class="bline">{_T string="Contribution type:"}</label>
					<select name="id_type_cotis" id="id_type_cotis"
						{if $type_selected eq 0}onchange="form.submit()"{/if}{if $required.id_type_cotis eq 1} required{/if}>
						{html_options options=$type_cotis_options selected=$contribution->type->id}
					</select>
    {if $type_selected eq 1}
                    <a class="button" id="btnback" href="javascript:back();" title="{_T string="Back to previous window, if you want to select a contribution type that is not listed here"}">{_T string="Back"}</a>
    {/if}
				</p>
			</fieldset>

    {if $type_selected eq 1}
			<fieldset class="cssform">
				<legend class="ui-state-active ui-corner-top">{_T string="Details of contribution"}</legend>
				<p>
					<label class="bline" for="montant_cotis">{_T string="Amount:"}</label>
					<input type="text" name="montant_cotis" id="montant_cotis" value="{$contribution->amount}" maxlength="10"{if $required.montant_cotis eq 1} required{/if}/>
				</p>
				<p>
					<label class="bline" for="date_debut_cotis">
                        {if $contribution->isCotis()}
							{_T string="Date of contribution:"}
						{else}
							{_T string="Start date of membership:"}
						{/if}
                    </label>
                    <input class="past-date-pick" type="text" name="date_debut_cotis" id="date_debut_cotis" value="{$contribution->begin_date}" maxlength="10"{if $required.date_debut_cotis eq 1} required{/if}/>
                    <span class="exemple">{_T string="(dd/mm/yyyy format)"}</span>
				</p>
        {if $contribution->isCotis()}
				<p>
            {if $pref_membership_ext != ""}
                    <label class="bline" for="duree_mois_cotis">{_T string="Membership extension:"}</label>
                    <input type="text" name="duree_mois_cotis" id="duree_mois_cotis" value="{$contribution->duration}" maxlength="3"{if $required.date_fin_cotis eq 1} required{/if}/>
                    <span class="exemple">{_T string="months"}</span>
            {else}
                    <label class="bline" for="date_fin_cotis">{_T string="End date of membership:"}</label>
                    <input type="text" name="date_fin_cotis" id="date_fin_cotis" value="{$contribution->end_date}" maxlength="10"{if $required.date_fin_cotis eq 1} required{/if}/>
                    <span class="exemple">{_T string="(dd/mm/yyyy format)"}</span>
            {/if}
				</p>
        {/if}
				<p>
					<label for="mail_confirm" class="bline">{_T string="Send a mail:"}</label>
					<input type="checkbox" name="mail_confirm" id="mail_confirm" value="1" {if $smarty.post.mail_confirm != ""}checked="checked"{/if}/>
					<span class="exemple">{_T string="(the member will receive a confirmation by email, if he has an address.)"}</span>
				</p>
				<p>
					<label class="bline" for="info_cotis">{_T string="Comments:"}</label>
					<textarea name="info_cotis" id="info_cotis" cols="61" rows="6"{if $required.info_cotis eq 1} required{/if}>{$contribution->info}</textarea>
				</p>
			</fieldset>
        {include file="display_dynamic_fields.tpl" is_form=true}
    {/if} {* $type_selected eq 1 *}
		</div>
		<div class="button-container">
    {if $type_selected eq 1}
			<input type="submit" id="btnsave" value="{_T string="Save"}"/>
			<input type="hidden" name="id_cotis" value="{$contribution->id}"/>
            {* Second step validator *}
			<input type="hidden" name="valid" value="1"/>
    {else} {* $type_selected ne 1 *}
			<input type="submit" value="{_T string="Continue"}"/>
            {* At creation time, we can get an amount, that will be hidden on the first step *}
			<input type="hidden" name="montant_cotis" value="{$contribution->amount}"/>
    {/if} {* $type_selected eq 1 *}
			<input type="hidden" name="trans_id" value="{$contribution->transaction->id}"/>
            {* First step validator *}
			<input type="hidden" name="type_selected" value="1"/>
		</div>
		<p>{_T string="NB : The mandatory fields are in"} <span class="required">{_T string="red"}</span></p>
		</form>
{/if}