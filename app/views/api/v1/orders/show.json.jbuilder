json.order_info do
  json.code @order.code
  json.created_at @order.created_at.strftime('%d/%m/%Y - %H:%M:%S')
  json.preparing_timestamp @order.preparing_timestamp.strftime('%d/%m/%Y - %H:%M:%S') if @order.preparing_timestamp
  json.done_timestamp @order.done_timestamp.strftime('%d/%m/%Y - %H:%M:%S') if @order.done_timestamp
  json.delivered_timestamp @order.delivered_timestamp.strftime('%d/%m/%Y - %H:%M:%S') if @order.delivered_timestamp
  json.status I18n.t(@order.status)
  json.cancel_reason @order.cancel_reason unless @order.cancel_reason.blank?
end

json.customer do 
  json.customer_name @order.customer_name
  json.customer_social_number @order.customer_social_number unless @order.customer_social_number.blank?
  json.customer_email @order.customer_email unless @order.customer_email.blank?
  json.customer_phone @order.customer_phone unless @order.customer_phone.blank?
end

if @order_portions.any?
  json.items @order_portions do |item|
    json.portion "#{item.portion.item.name} - #{item.portion.description}"
    json.qty item.qty
    json.description item.description unless item.description.blank?
  end
end
