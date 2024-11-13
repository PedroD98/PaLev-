json.order do
  json.customer_name @order.customer_name
  json.created_at @order.created_at.strftime('%d/%m/%Y')
  json.status I18n.t(@order.status)
end

if @order_portions.any?
  json.items @order_portions do |item|
    json.portion "#{item.portion.item.name} - #{item.portion.description}"
    json.qty item.qty
    json.description item.description unless item.description.blank?
  end
end
