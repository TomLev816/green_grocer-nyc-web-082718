require "pry"
def consolidate_cart(cart)
  cartHash = {}
  cart.each do |hash|
    hash.each do |item, info|
      if hash[item][:count]
        hash[item][:count] += 1
      else
        hash[item][:count] = 1
      end
    end
  end
  result = cart.uniq
  result.each do |hashAgain|
    hashAgain.each do |key, attribute|
      cartHash[key] = attribute
    end
  end
  return cartHash
end # This works but it looks awful. It took me a while to figure out that return cart.uniq was an array

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    name = coupon[:item]
    if cart[name]
      if (cart[name][:count] - coupon[:num]) >= 0
        cart[name][:count] -= coupon[:num]
        if cart["#{name} W/COUPON"]
          cart["#{name} W/COUPON"][:count] += 1
        else
          couponName = "#{name} W/COUPON"
          cart[couponName] = {}
          cart[couponName][:price] = coupon[:cost]
          cart[couponName][:clearance] = cart[name][:clearance]
          cart[couponName][:count] = 1
        end
      end
    end
  end
  return cart
end

def apply_clearance(cart)
  cart.each do |item, info|
    if cart[item][:clearance]
      cart[item][:price] = (cart[item][:price] * 0.8).round(2)
    end
  end
  return cart
end

def checkout(cart, coupons)

  total = 0
  conCart = consolidate_cart(cart)
  #binding.pry
  conCart = apply_coupons(conCart, coupons)
  conCart = apply_clearance(conCart)
  conCart.each do |key, value|
    total += conCart[key][:price] * conCart[key][:count]
  end
  if total > 100
    total = (total * 0.9).round(2)
  end
  #binding.pry
  return total
end
