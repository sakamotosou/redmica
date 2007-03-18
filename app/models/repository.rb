# redMine - project management software
# Copyright (C) 2006  Jean-Philippe Lang
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

class Repository < ActiveRecord::Base
  belongs_to :project
  validates_presence_of :url
  validates_format_of :url, :with => /^(http|https|svn|file):\/\/.+/i
    
  def scm
    @scm ||= SvnRepos::Base.new url, root_url, login, password
    update_attribute(:root_url, @scm.root_url) if root_url.blank?
    @scm
  end
  
  def url=(str)
    unless str == self.url
      self.attributes = {:root_url => nil }
      @scm = nil
    end
    super
  end
end
