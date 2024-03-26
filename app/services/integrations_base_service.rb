class IntegrationsBaseService
  def self.call(*args, **kwargs)
    new.call(*args, **kwargs)
  end

  def call
    raise NotImplementedError
  end

  def self.transform_attributes(hash, mapping: [])
    mapping.each_with_object({}) do |(key, value), attributes|
      attributes[value] = hash[key]
    end
  end
end
