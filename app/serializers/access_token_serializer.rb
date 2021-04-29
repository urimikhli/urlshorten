class AccessTokenSerializer #< ActiveMdel::Serializer
  include JSONAPI::Serializer
  attributes :token
end
