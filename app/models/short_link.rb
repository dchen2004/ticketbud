class ShortLink < ApplicationRecord
  RESTRICTED_PATHS = %w(
    short_links
    forward
  )

  validates :slug, presence: true, length: { in: 2..100 },
    format: { with: /\A[a-zA-Z0-9\-_]+\z/ }, uniqueness: true
  validates :destination_url, presence: true, length: { in: 2..255 },
    format: { with: URI.regexp }

  # routes should be restricted.
  validate :restrictied_paths_validate

  private

  def restrictied_paths_validate
    return unless RESTRICTED_PATHS.include?(slug)
    errors.add :slug, 'is not allowed'
  end
end
