class Attachment < ActiveRecord::Base
  belongs_to :post
  attr_accessible :attachment_name, :post_id
  mount_uploader :attachment_name, AttachmentUploader

end
