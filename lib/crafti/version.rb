module Crafti
  MAJOR = 0
  MINOR = 0
  PATCH = 20

  def self.version
    [
      MAJOR, MINOR, PATCH
    ].join('.')
  end
end
