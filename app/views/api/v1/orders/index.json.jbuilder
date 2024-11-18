json.orders @orders do |order|

  json.code order.code
  json.customer_name order.customer_name
  json.customer_social_number order.customer_social_number
  json.customer_email order.customer_email
  json.customer_phone order.customer_phone
  json.created_at order.created_at.strftime('%d/%m/%Y - %H:%M:%S')
  json.status I18n.t(order.status)
end
