class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController 
    def facebook 
    # You need to implement the method below in your model (e.g. app/models/user.rb) 
        @user = User.from_omniauth(request.env["omniauth.auth"]) 
        if @user.persisted? 
            sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated 
            set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format? 
        else 
            session["devise.facebook_data"] = request.env["omniauth.auth"] 
            redirect_to new_user_session_url, alert: "email già presente nel sistema"
        end 
    end 

    def google_oauth2
        @user=User.from_omniauth(request.env["omniauth.auth"])
        if @user.persisted? 
            sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated 
            flash[:success] = t 'devise.omniauth_callbacks.success', kind: 'Google'
        else
            #session["devise.google_oauth2_data"] = request.env["omniauth.auth"]
            redirect_to new_user_session_url, alert: "email già presente nel sistema"
        end
    end



     
    def failure 
        redirect_to '/' 
    end 
end