=begin
Swagger Petstore

No description provided (generated by Openapi Generator https://github.com/openapitools/openapi-generator)

The version of the OpenAPI document: 1.0.0
Generated by: https://github.com/openapitools/openapi-generator.git

=end


class Pet < ApplicationRecord
  validates_presence_of :id
  validates_presence_of :name

end
