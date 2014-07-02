xml.instruct! :xml, :version=>"1.0"
xml.rss(:version=>"2.0", "xmlns:g" => "http://base.google.com/ns/1.0"){
  xml.channel{
    xml.title(current_store_title)
    xml.link(current_store_link)
    xml.description(current_store_description)
    xml.language('en-us')
    @products.each do |product|
      xml.item do
        xml.title { |t| t.cdata! product.name }
        xml.description { |t| t.cdata! product_description(product) }
        xml.author(current_store_title)
        xml.pubDate((product.available_on || product.created_at).strftime("%a, %d %b %Y %H:%M:%S %z"))
        xml.link(product_url(product))

        if product.images.count > 0
          xml.tag!('g:image_link', product_image_link(product.images.first.attachment.url(:large)))
        end

        xml.tag!('g:id', product.id)

        xml.tag!('g:age_group', 'adult')
        xml.tag!('g:availability', product.has_stock? ? 'in stock' : 'out of stock')
        xml.tag!('g:brand', product_brand(product))
        xml.tag!('g:product_type'){|t| t.cdata! product_type(product) }
        xml.tag!('g:color', product_color(product.variants.try(:first)))
        xml.tag!('g:gender', product_gender(product))
        xml.tag!('g:google_product_category'){|t| t.cdata! google_product_category(product) }
        xml.tag!('g:condition', 'new')
        xml.tag!('g:identifier_exists', 'TRUE')
        xml.tag!('g:mpn', product.sku)
        xml.tag!('g:price', product_price(product.price))
        xml.tag!('g:shipping_weight', "1 lb")
      end
    end
  }
}
