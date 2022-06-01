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
      assert_select 'tbody tr', count: 2
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
      assert_select 'td', forward_url(slug: short_link.slug)
      assert_select 'td', short_link.destination_url
    end
  end

  describe 'new shortlink' do
    it 'new shortlink page' do
      get "/short_links/new"
      assert_select '#short_link_slug'
      assert_select '#short_link_destination_url'
      assert_select 'input[type="submit"][value="Create Short link"]'
    end
  end

  describe 'create shortlink' do
    describe 'validation' do
      it 'should not create if slug is empty' do
        assert_no_difference 'ShortLink.count' do
          post '/short_links',
            params: { short_link: short_link_params.merge(slug: nil) }
        end
        assert_select '.alert'
      end

      it 'should not create if slug is invalid' do
        assert_no_difference 'ShortLink.count' do
          post '/short_links',
            params: { short_link: short_link_params.merge(slug: 'gith ub') }
        end
        assert_select '.alert'
      end

      it 'should not create if slug is wrong length' do
        assert_no_difference 'ShortLink.count' do
          post '/short_links',
            params: { short_link: short_link_params.merge(slug: 'g') }
        end
        assert_select '.alert'
      end

      it 'should not create if slug is restricted path' do
        assert_no_difference 'ShortLink.count' do
          post '/short_links',
            params: { short_link: short_link_params.merge(slug: 'short_links') }
        end
        assert_select '.alert'
      end

      it 'should not create if destination url is empty' do
        assert_no_difference 'ShortLink.count' do
          post '/short_links',
            params: { short_link: short_link_params.merge(destination_url: nil) }
        end
        assert_select '.alert'
      end

      it 'should not create if destination url is not valid url' do
        assert_no_difference 'ShortLink.count' do
          post '/short_links',
            params: { short_link: short_link_params.merge(destination_url: 'asdfbdsf') }
        end
        assert_select '.alert'
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
      assert_select 'input[type="submit"][value="Update Short link"]'
    end
  end

  describe 'update shortlink' do
    # Skip validation test because it was already defined on 'create'
    it 'update short link' do
      put "/short_links/#{short_link.id}", params: { short_link: short_link_params }
      assert_equal 'github', short_link.reload.slug
      assert_equal 'https://github.com', short_link.destination_url
      assert_redirected_to root_path
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
