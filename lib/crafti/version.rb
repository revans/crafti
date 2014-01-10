module Crafti
  MAJOR = 0
  MINOR = 0
  PATCH = 15

  def self.version
    [
      MAJOR, MINOR, PATCH
    ].join('.')
  end
end
