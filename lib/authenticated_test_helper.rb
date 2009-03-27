module AuthenticatedTestHelper
  # Sets the current person in the session from the person fixtures.
  def login_as(person)
    @request.session[:user_id] = person ? (person.is_a?(Person) ? person.id : people(person).id) : nil
  end

  def authorize_as(person)
    @request.env["HTTP_AUTHORIZATION"] = person ? ActionController::HttpAuthentication::Basic.encode_credentials(people(person).login, 'monkey') : nil
  end
  
end
