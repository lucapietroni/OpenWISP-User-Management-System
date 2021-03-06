# encoding: utf-8
# This file is part of the OpenWISP User Management System
#
# Copyright (C) 2012 OpenWISP.org
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

class User < AccountCommon

  # Authlogic
  acts_as_authentic do |c|
    c.maintain_sessions = false
  end


  self.before_validation do |record|
	record.pf_luogo_di_nascita = record.pf_luogo_di_nascita.to_s.capitalize
	record.pg_comune = record.pg_comune.to_s.capitalize
  	record.city= record.city.to_s.capitalize
  	record.given_name = record.given_name.to_s.capitalize
  	record.surname = record.surname.to_s.capitalize
  	record.address = record.address.to_s.titleize
  	record.pg_indirizzo = record.pg_indirizzo.to_s.titleize
    # Cleaning up unused fields... just in case..
    if record.verify_with_document?
	    #  record.mobile_prefix = nil
	    #  record.mobile_suffix = nil
    elsif record.verify_with_mobile_phone?
       record.image_file_data = nil
    end
  end


  # Validations
  validate :verification_method_inclusion
  validates :pf_cf, :if => :verify_with_document?, :codice_fiscale_format => true, :presence => true
  validates :pg_partita_iva,
	:presence => true,
	:format => {:with => /\A[0-9]{11}\Z/i, :message => :pg_partita_format, :allow_blank => true}
 
  
  validates :iban, :presence => true, :if => [:verify_with_document?], :unless => [:paypal?]
  			 
  validates :product_ids, :if => :verify_with_document?, :presence => true
  validates :cpe_template_id, :if => :verify_with_document?, :presence => true
  
  validates :mobile_prefix, :if => :verify_with_document?,
            :presence => true,
            :format => {:with => /\A[0-9]{2,3}\Z/i, :message => :m_prefix_format, :allow_blank => true}
            
  validates :mobile_suffix, :if => :verify_with_document?,
            :presence => true,
            :format => {:with => /\A[0-9]{4,8}\Z/i, :message => :m_suffix_format, :allow_blank => true}

  validates :pf_luogo_di_nascita, :if => :verify_with_document?,
            :presence => true,
            :format => {:with => /\A(\w|[\s'\.,\-àèéìòù])+\Z/i, :message => :address_format, :allow_blank => true}

  validates :pg_ragione_sociale, :if => :is_company?,
            :presence => true,
            :format => {:with => /\A(\w|[\s'\.,\-àèéìòù])+\Z/i, :message => :name_format, :allow_blank => true}

  validates :pg_indirizzo, :if => :is_company?,
            :presence => true,
            :format => {:with => /\A(\w|[\s'\.,\/\-àèéìòù])+\Z/i, :message => :address_format, :allow_blank => true}

  validates :pg_comune, :if => :is_company?,
            :presence => true,
            :format => {:with => /\A(\w|[\s'\.,\-àèéìòù])+\Z/i, :message => :address_format, :allow_blank => true}

  validates :pg_cap, :if => :is_company?,
            :presence => true,
            :format => {:with => /[a-z0-9]/, :message => :zip_format, :allow_blank => true}

  validates :inst_cpe_mac, :if => :verify_with_document?,
            :presence => true,
#            :format => {:with => /^([0-9a-fA-F]{2}[:-]){5}[0-9a-fA-F]{2}$/i, :message => :mac_format, :allow_blank => true}
            :format => {:with => /^([0-9a-fA-F]{2}){5}[0-9a-fA-F]{2}$/i, :message => :mac_format, :allow_blank => true}
  
  has_many :radius_replies, :as => :radius_entity, :dependent => :destroy
  has_many :operator_users, :dependent => :destroy
  
  belongs_to :cpe_template
  
  
  
  attr_accessible :given_name, :surname, :birth_date, :state, :city, :address, :zip,
                  :email, :email_confirmation, :password, :password_confirmation,
                  :mobile_prefix, :mobile_suffix, :verified, :verification_method,
                  :notes, :eula_acceptance, :privacy_acceptance,
                  :username, :image_file_temp, :image_file, :image_file_data, :radius_group_ids, :product_ids,
                  :tax_code, :vat_number, :iban, :product_id, :cpe_template_id, :pg_ragione_sociale, :pg_partita_iva,
                  :pg_indirizzo, :pg_cap, :pf_cf, :pf_luogo_di_nascita, :inst_indirizzo, :inst_cap, :inst_cpe_modello,
                  :inst_cpe_username, :inst_cpe_password, :inst_cpe_mac, :gen_note, :is_company, :pg_comune, :has_credits, :paypal

  # Custom validations

  def verification_method_inclusion
    valid_verification_methods = User.verification_methods + (self.new_record? ? [] : User.self_verification_methods)

    errors.add(:verification_method, I18n.t(:inclusion, :scope => [:activerecord, :errors, :messages])) unless valid_verification_methods.include?(verification_method)
  end

  # Class methods

  def self.last_registered(num = 5)
    User.order("created_at DESC").limit(num)
  end

  def self.find_by_id_or_username!(id)
    User.find id
  rescue ActiveRecord::RecordNotFound
    User.find_by_username! id
  end

  # Class Method:
  #   top_traffic()
  # Description:
  #   Returns most active (traffic pov) users
  # Input:
  #   Max number of users
  # Output
  #   Hash { :user => <User model instance>,  :total_traffic => <total traffic (bytes)> }
  def self.top_traffic(num = 5)
    top = RadiusAccounting.all(:select => 'UserName',
                               :group => :UserName,
                               :order => 'sum(AcctInputOctets + AcctOutputOctets) DESC',
                               :limit => num)
    ret = []
    top.each do |t|
      user = User.find_by_username(t.UserName) # See the above select
      ret.push(user) unless user.nil?
    end

    ret
  end
  


  def self.find_all_by_user_phone_or_mail(query)
    where(["username = ? OR CONCAT(mobile_prefix,mobile_suffix) = ? OR email = ?"] + [query]*3)
  end

  def self.registered_each_day(from, to)
    (from..to).map { |that_day|
      on_that_day = User.registered_on(that_day)
      [that_day.to_datetime.to_i * 1000, on_that_day] if on_that_day > 0
    }.compact
  end
  
  def self.registered_daily(from, to)
    (from..to).map { |that_day|
      on_that_day = User.count :conditions => ["DATE(verified_at) = ?", that_day.to_s] 
      [that_day.to_datetime.to_i * 1000, on_that_day] if on_that_day > 0
    }.compact
  end

  def self.registered_on(date)
    count :conditions => ["DATE(verified_at) <= ?", date.to_s]
  end

  def self.registered_yesterday
    where({:created_at => 1.day.ago..DateTime.now})
  end

  def self.unverified
    where("verified_at is NULL AND NOT verified")
  end

  def self.disabled
    # This method uses verified_at and verified instead
    # of active, to let the user disable (and subsequent remove)
    # itself autonomously
    where("verified_at is NOT NULL AND NOT verified")
  end

  # Instance Methods

  def to_xml(options={})
    options.merge!(:include => :radius_groups)
    super(options)
  end

  # Utilities

  def can_signup_via?(verification_method)
    User.verification_methods.include? verification_method
  end

  def total_traffic
    self.radius_accountings.sum('AcctInputOctets + AcctOutputOctets')
  end

  def radius_name
    username
  end

  def mobile_phone
    if self.verify_with_mobile_phone?
      "#{self.mobile_prefix}#{self.mobile_suffix}"
    else
      Rails.logger.error("Verification method is not 'mobile_phone'!")
    end
  end

  def mobile_phone=(value)
    if self.verify_with_mobile_phone?
      self.mobile_prefix = value[0..2]
      self.mobile_suffix = value[3, -1]
    else
      Rails.logger.error("Verification method is not 'mobile_phone'!")
    end
  end

  def credit_card_identity_verify!(buy_product_id, buy_radius_group_id)
    
    if self.verify_with_credit_card?
      #verify user and set has_credits true 
      self.verified = true
      self.has_credits = true
      self.save(:validate => false)
      if buy_radius_group_id
        #assign radius group to user 
				self.radius_group_ids = [buy_radius_group_id]
				#assign product to user
				self.product_ids = [buy_product_id]
				self.save(:validate => false)
      	radius_group = RadiusGroup.find(buy_radius_group_id)
      	#create radius check attributes
      	create_user_attribute_entry(self, radius_group)
      end
#      self.new_account_notification!
    else
      Rails.logger.error("Verification method is not 'credit_card'!")
    end
  end

  def mobile_phone_identity_verify!
    if self.verify_with_mobile_phone?
      self.verified = true
      self.save!
      self.new_account_notification!
    else
      Rails.logger.error("Verification method is not 'mobile_phone'!")
    end
  end

  def mobile_phone_password_recover!
    if self.verify_with_mobile_phone?
      self.recovered = true
      self.save!
    else
      Rails.logger.error("Verification method is not 'mobile_phone'!")
    end
  end

  def mobile_phone_identity_verify_or_password_recover!
    if self.verified?
      Rails.logger.info("Password recover for '#{self.username}' (id: #{self.id})")
      unless self.recovered?
        self.mobile_phone_password_recover!
        return true
      end
    else
      Rails.logger.info("Verifying '#{self.username}' (id: #{self.id})")
      self.mobile_phone_identity_verify!
      # If the user is not verified because she has disabled her account
      # (i.e. verified == false and recovered == false)
      # we have to recover her password.
      # Default value for recovered is nil (!= false)
      unless self.recovered
        self.mobile_phone_password_recover!
      end
      return true
    end
    false
  end

  def registration_expire_timeout
    if self.disabled?
      Configuration.get('disabled_account_expire_days').to_i.days
    else
      Rails.logger.error("Account not disabled")
      raise "Account not disabled"
    end
  end

  def registration_expired?
    expire_in = self.registration_expire_timeout
    expire_in != 0 && (self.updated_at + expire_in) <= Time.now
  end

  # Accessors

  def recovered=(value)
    write_attribute(:recovered, value)
    self.recovered_at = Time.now()
  end
  
  def create_user_attribute_entry(account, radius_group)
  	user_max_all_session = account.radius_checks.user_check_att_value
  	unless user_max_all_session
  		attr = [:check_attribute => "Max-All-Session",
  					  :op => ":=",
  					  :value => radius_group.radius_checks.radius_check_att_value.value,
  					  :radius_entity => account,
  					  :radius_entity_type => "AccountCommon"]
  		RadiusCheck.create(attr)
  	else
  		rg_att = radius_group.radius_checks.radius_check_att_value
  		radius_group_att_value = 0
  		if rg_att
  			radius_group_att_value = rg_att.value.to_i
  		end
			total = user_max_all_session.value.to_i + radius_group_att_value
			user_max_all_session.value = total
			user_max_all_session.save
  	end
  end

end
