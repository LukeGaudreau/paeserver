# Rendering XML is super easy using Builder! See show.haml for explanations of logic, everything here is just modifed to work with builder. 
xml.instruct! :xml, :version => '1.0', :encoding => 'utf-8'
xml.pae 'classified' => @pae.classified, 'idno' => @pae.id do
  xml.title @pae.title
  xml.date @pae.date
  xml.url @pae.url
  xml.authors do
    @pae.authors.each do |author,i|
      xml.author do
        xml.huid author.huid
        xml.name do
          xml.fname author.fname
          xml.lname author.lname
        end
      end
    end
  end
  xml.advisors do
    @pae.advisors.each do |advisor,i|
      xml.advisor do
        xml.name do
          xml.fname advisor.fname
          xml.lname advisor.lname
        end
      end
    end
  end
  xml.clients do
    @pae.clients.each do |client,i|
      xml.client do
        xml.org_name client.org_name
        xml.org_contact do
          xml.name do
            xml.fname client.fname
            xml.lname client.lname
          end
          xml.position client.position
        end
      end
    end
  end
  xml.policy_areas do
    @pae.area_paes.each do |area,i|
      @area = Area.first( :slug.like => area.area_slug )
      xml.policy_area @area.title
    end
  end
end