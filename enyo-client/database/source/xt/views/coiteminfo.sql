select xt.create_view('xt.coiteminfo', $$

select coitem.*,
  xt.co_line_base_price(coitem) as base_price,
  xt.co_line_markup(coitem) as markup,
  xt.co_line_list_price(coitem) as list_price,
  xt.co_line_list_price_discount(coitem) as list_price_discount,
  xt.co_line_customer_discount(coitem) as cust_discount,
  xt.co_line_extended_price(coitem) as ext_price, 
  xt.co_line_profit(coitem) as profit,
  xt.co_line_tax(coitem) as tax
from coitem
  left join itemsite on coitem_itemsite_id=itemsite_id 
  left join item on itemsite_item_id=item_id;

$$, false);

create or replace rule "_INSERT" as on insert to xt.coiteminfo do instead

insert into coitem (
  coitem_id,
  coitem_cohead_id,
  coitem_linenumber,
  coitem_itemsite_id,
  coitem_scheddate,
  coitem_qtyord,
  coitem_unitcost,
  coitem_price,
  coitem_custprice,
  coitem_memo,
  coitem_custpn,
  coitem_prcost,
  coitem_imported,
  coitem_qty_uom_id,
  coitem_qty_invuomratio,
  coitem_price_uom_id,
  coitem_price_invuomratio,
  coitem_promdate,
  coitem_taxtype_id,
  coitem_status,
  coitem_qtyshipped,
  coitem_order_id,
  coitem_qtyreturned,
  coitem_closedate,
  coitem_order_type,
  coitem_close_username,
  coitem_lastupdated,
  coitem_substitute_item_id,
  coitem_created,
  coitem_creator,
  coitem_warranty,
  coitem_cos_accnt_id,
  coitem_qtyreserved,
  coitem_subnumber,
  coitem_firm,
  coitem_rev_accnt_id,
  coitem_pricemode
) select
  new.coitem_id,
  new.coitem_cohead_id,
  new.coitem_linenumber,
  new.coitem_itemsite_id,
  new.coitem_scheddate,
  new.coitem_qtyord,
  stdcost(itemsite_item_id),
  new.coitem_price,
  new.coitem_custprice,
  new.coitem_memo,
  new.coitem_custpn,
  new.coitem_prcost,
  new.coitem_imported,
  new.coitem_qty_uom_id,
  new.coitem_qty_invuomratio,
  new.coitem_price_uom_id,
  new.coitem_price_invuomratio,
  new.coitem_promdate,
  new.coitem_taxtype_id,
  new.coitem_status,
  COALESCE(new.coitem_qtyshipped, 0),
  new.coitem_order_id,
  new.coitem_qtyreturned,
  new.coitem_closedate,
  new.coitem_order_type,
  new.coitem_close_username,
  COALESCE(new.coitem_lastupdated, now()),
  new.coitem_substitute_item_id,
  new.coitem_created,
  new.coitem_creator,
  new.coitem_warranty,
  new.coitem_cos_accnt_id,
  COALESCE(new.coitem_qtyreserved, 0),
  new.coitem_subnumber,
  new.coitem_firm,
  new.coitem_rev_accnt_id,
  new.coitem_pricemode
from itemsite
where itemsite_id=new.coitem_itemsite_id;

create or replace rule "_UPDATE" as on update to xt.coiteminfo do instead

update coitem set
  coitem_id=new.coitem_id,
  coitem_cohead_id=new.coitem_cohead_id,
  coitem_linenumber=new.coitem_linenumber,
  coitem_scheddate=new.coitem_scheddate,
  coitem_qtyord=new.coitem_qtyord,
  coitem_price=new.coitem_price,
  coitem_custprice=new.coitem_custprice,
  coitem_memo=new.coitem_memo,
  coitem_custpn=new.coitem_custpn,
  coitem_prcost=new.coitem_prcost,
  coitem_imported=new.coitem_imported,
  coitem_qty_uom_id=new.coitem_qty_uom_id,
  coitem_qty_invuomratio=new.coitem_qty_invuomratio,
  coitem_price_uom_id=new.coitem_price_uom_id,
  coitem_price_invuomratio=new.coitem_price_invuomratio,
  coitem_promdate=new.coitem_promdate,
  coitem_taxtype_id=new.coitem_taxtype_id,
  coitem_status = new.coitem_status,
  coitem_qtyshipped = COALESCE(new.coitem_qtyshipped, 0),
  coitem_order_id = new.coitem_order_id,
  coitem_qtyreturned = new.coitem_qtyreturned,
  coitem_closedate = new.coitem_closedate,
  coitem_order_type = new.coitem_order_type,
  coitem_close_username = new.coitem_close_username,
  coitem_lastupdated = COALESCE(new.coitem_lastupdated, now()),
  coitem_substitute_item_id = new.coitem_substitute_item_id,
  coitem_created = new.coitem_created,
  coitem_creator = new.coitem_creator,
  coitem_warranty = new.coitem_warranty,
  coitem_cos_accnt_id = new.coitem_cos_accnt_id,
  coitem_qtyreserved = COALESCE(new.coitem_qtyreserved, 0),
  coitem_subnumber = new.coitem_subnumber,
  coitem_firm = new.coitem_firm,
  coitem_rev_accnt_id = new.coitem_rev_accnt_id,
  coitem_pricemode=new.coitem_pricemode
where coitem_id = old.coitem_id;

create or replace rule "_DELETE" as on delete to xt.coiteminfo do instead

delete from coitem where coitem_id = old.coitem_id;
