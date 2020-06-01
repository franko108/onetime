require 'securerandom'

OnetimeSecure::App.controllers :onetime do

  # get :index, :map => '/foo/bar' do
  #   session[:foo] = 'bar'
  #   render 'index'
  # end

  # get :sample, :map => '/sample/url', :provides => [:any, :js] do
  #   case content_type
  #     when :js then ...
  #     else ...
  # end

  # get :foo, :with => :id do
  #   "Maps to url '/foo/#{params[:id]}'"
  # end

   get '/example' do
     'Hello world!'
   end

  get :index, :map => '/' do
	 render 'index'

  end

  post :create,  :map => '/create' do
      uuidb = SecureRandom.uuid
      sec = params[:secret]

      if sec == ''
          @error = 'Error, you must enter some valid content!'
          render 'index'
      elsif  sec.length > 255
          @error = 'Error, your string has more then 255 characters!'
          render 'index'

      else
          @onetime = Onetime.new(uuid: uuidb, content: sec)
          @onetime.save

          @uuid_view = uuidb
          @web_url = "#{request.scheme}://#{request.host}/onetime/show/#{uuidb}"

          render 'created'
      end

  end


   # check if url is valid, then proceed to show2
   get :show, :with => :id do
     "Maps to url '/show/:   #{params[:id]}'"
     #@onetime = Onetime[id: params[:id]]  # ovo radi za id
     @onetime = Onetime[uuid: params[:id]]
     if @onetime
        #@error = 'Click on the link to see one time content: <a href="show2/#{params[:id]}">Here</a>'
        @url_path = "../show2/#{params[:id]}"

        render 'onetime/show'
     else

        #halt 404
        # to decide what to do, maybe session, and after 3 times get lost!
        @error = 'URL is invalid, it does not exist, or never existed, please enter a new value if needed!'
        render 'index'

     end
    end

    # show actual content and delete it from database
     get :show2, :with => :id do
       "Maps to url '/show2/:   #{params[:id]}'"
       #@onetime = Onetime[id: params[:id]]  # ovo radi za id
       @onetime = Onetime[uuid: params[:id]]
       if @onetime
          @onteime2 = Onetime[uuid: params[:id]].delete

          render 'onetime/show2'
       else

          #halt 404
          # to decide what to do, maybe session, and after 3 times get lost!
          @error = 'URL is invalid, it does not exist, or never existed, please enter a new value if needed!'
          render 'index'

       end

    end



end
