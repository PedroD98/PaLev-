json.order_info do
  json.code @order.code
  json.created_at @order.created_at.strftime('%d/%m/%Y - %H:%M:%S')
  json.status I18n.t(@order.status)
  json.cancel_reason @order.cancel_reason unless @order.cancel_reason.blank?
end

json.customer do 
  json.customer_name @order.customer_name
  json.customer_social_number @order.customer_social_number
  json.customer_email @order.customer_email
  json.customer_phone @order.customer_phone
end

if @order_portions.any?
  json.items @order_portions do |item|
    json.portion "#{item.portion.item.name} - #{item.portion.description}"
    json.qty item.qty
    json.description item.description unless item.description.blank?
  end
end
