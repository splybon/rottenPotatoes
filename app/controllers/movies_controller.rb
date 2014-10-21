class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @order = params[:order]      #obtains the order from the paramters sent from user input
    @all_ratings = Movie.pluck(:rating).uniq   #selects ratings and puts in an array ['P', 'PG', 'PG-13', 'R']

    
    if params[:ratings] == nil               #If first time to site
      @movies = Movie.order(params[:order])  #Orders the movies by the order sent in by user
      @checked = @all_ratings                #checks all boxes
    else
      @movies = Movie.where(rating: params[:ratings].keys).order(params[:order])   #Selects only the ratings the user gives
      @checked = params[:ratings].keys                                       #returns an array of the ratings selected by user
    end    

    if !params[:order].nil?
      session[:order] = params[:order]  #places order paramater in the session unless there isn't one
    end
    if !params[:ratings].nil?
      session[:ratings] = params[:ratings] #places the ratings parameter in the session unless there isn't one
    end


    if ( params[:ratings].nil? || params[:order].nil? )
      if session[:order].nil? && !session[:ratings].nil?
        redirect_to movies_path(:order => (""), :ratings => (session[:ratings]))
      elsif !session[:order].nil? && !session[:ratings].nil?
        redirect_to movies_path(:order => (session[:order]), :ratings => (session[:ratings]))
      elsif session[:order].nil? && session[:ratings].nil?
        redirect_to movies_path(:order => (""), :ratings => {"G"=>"1", "PG"=>"1", "PG-13"=>"1", "R"=>"1"})
      elsif !session[:order].nil? && session[:ratings].nil?
        redirect_to movies_path(:order => (session[:order]), :ratings => {"G"=>"1", "PG"=>"1", "PG-13"=>"1", "R"=>"1"})
      end
    end

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
