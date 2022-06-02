require 'test_helper'

describe ShortLinksController do
  let(:short_link)           { short_links :one}
  let(:short_link_params)  {
    {
      slug: 'github',
      destination_url: 'https://github.com'
    }
  }

  describe 'shortlink listings' do
    it 'show all shortlinks' do
      get '/short_links'
      assert_select '.table__body .table__row', count: 2
    end

    it 'show welcome if there is no short link' do
      ShortLink.destroy_all
      get '/short_links'
      assert_select 'div', /Create your first ShortLink/
    end
  end

  describe 'show shortlink' do
    it 'show shortlink page' do
      get "/short_links/#{short_link.id}"
      assert_select 'dd', forward_url(slug: short_link.slug)
      assert_select 'dd', short_link.destination_url
    end
  end

  describe 'new shortlink' do
    it 'new shortlink page' do
      get "/short_links/new"
      assert_select '#short_link_slug'
      assert_select '#short_link_destination_url'
      assert_select 'button', /Create Short link/
    end
  end

  describe 'create shortlink' do
    describe 'validation' do
      it 'should not create if slug is empty' do
        assert_no_difference 'ShortLink.count' do
          post '/short_links',
            params: { short_link: short_link_params.merge(slug: nil) }
        end
        assert_select '.alert', /Slug can't be blank/
      end

      it 'should not create if slug is invalid' do
        assert_no_difference 'ShortLink.count' do
          post '/short_links',
            params: { short_link: short_link_params.merge(slug: 'gith ub') }
        end
        assert_select '.alert', /Slug is invalid/
      end

      it 'should not create if slug is wrong length' do
        assert_no_difference 'ShortLink.count' do
          post '/short_links',
            params: { short_link: short_link_params.merge(slug: 'g') }
        end
        assert_select '.alert', /Slug is too short/
      end

      it 'should not create if slug is restricted path' do
        assert_no_difference 'ShortLink.count' do
          post '/short_links',
            params: { short_link: short_link_params.merge(slug: 'short_links') }
        end
        assert_select '.alert', /Slug is not allowed/
      end

      it 'should not create if destination url is empty' do
        assert_no_difference 'ShortLink.count' do
          post '/short_links',
            params: { short_link: short_link_params.merge(destination_url: nil) }
        end
        assert_select '.alert', /Destination url can't be blank/
      end

      it 'should not create if destination url is not valid url' do
        assert_no_difference 'ShortLink.count' do
          post '/short_links',
            params: { short_link: short_link_params.merge(destination_url: 'asdfbdsf') }
        end
        assert_select '.alert', /Destination url is invalid/
      end

      it 'should not create if slug is existed' do
        assert_no_difference 'ShortLink.count' do
          post '/short_links',
            params: { short_link: short_link_params.merge(slug: 'ticketbud') }
        end
        assert_select '.alert', /Slug has already been taken/
      end
    end

    it 'new shortlink create' do
      assert_difference 'ShortLink.count' do
        post '/short_links', params: { short_link: short_link_params }
      end
      assert_redirected_to root_path
      follow_redirect!
      assert_select '.notice', /The ShortLink has been created./
      new_short_link = ShortLink.last
      assert_equal 'github', new_short_link.slug
      assert_equal 'https://github.com', new_short_link.destination_url
    end
  end

  describe 'edit shortlink' do
    it 'edit shortlink page' do
      get "/short_links/#{short_link.id}/edit"
      assert_select '#short_link_slug'
      assert_select '#short_link_destination_url'
      assert_select 'button', /Update Short link/
    end
  end

  describe 'update shortlink' do
    # Skip validation test because it was already defined on 'create'
    it 'update short link' do
      put "/short_links/#{short_link.id}", params: { short_link: short_link_params }
      assert_equal 'github', short_link.reload.slug
      assert_equal 'https://github.com', short_link.destination_url
      assert_redirected_to short_link_path(short_link)
      follow_redirect!
      assert_select '.notice', /The ShortLink has been updated./
    end
  end

  describe 'destroy shortlink' do
    it 'destroy short link' do
      assert_difference 'ShortLink.count', -1 do
        delete "/short_links/#{short_link.id}"
      end
      assert_redirected_to root_path
      follow_redirect!
      assert_select '.notice', /The ShortLink has been destroyed./
    end
  end
end
