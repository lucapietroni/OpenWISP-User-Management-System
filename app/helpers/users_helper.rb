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

module UsersHelper
  def sort_td_class_helper(param)
    result = case params[:sort]
               when param          then 'sortup'
               when param + "_rev" then 'sortdown'
               else 'nosort'
             end

    raw "class=\"#{result}\""
  end

  def sort_remote_link_helper(text, field)
    key = field
    key += "_rev" if params[:sort] == field

    raw link_to(text, params.merge(:sort => key, :page => nil), :remote => true, :title => t(:Sort_by_this_field))
  end


  def user_verification_methods
    User.verification_methods
  end

  def user_verification_select
    user_verification_methods.map{ |method| [ t(method.to_sym), method ] }
  end
        def remaining_time_to_surf_operator_view
		unless @user.has_credits
			return "00:00:00"
		end
		rad_acc = RadiusAccounting.where(:username => @user.username, :is_surf => true)
		user_check_att = @user.radius_checks.user_check_att_value
		total_sec = 0
		if rad_acc.count > 0
			total_sec = rad_acc.last.total_surfing_time
			if user_check_att
				if user_check_att.value.to_i > total_sec.to_i
					total = user_check_att.value.to_i - total_sec.to_i
					return Time.at(total).gmtime.strftime('%R:%S')
				end
			end
		else
			return user_check_att ? Time.at(user_check_att.value.to_i).gmtime.strftime('%R:%S') : "00:00:00"		
		end
		
	end
end
