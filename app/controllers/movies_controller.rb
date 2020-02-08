class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings
    @sort = params[:sort] || session[:sort]
    session[:ratings] = session[:ratings]|| {'G'=>'', 'PG'=>'', 'PG-13'=>'', 'R'=>''}
    @ratParam = params[:ratings] || session[:ratings]
    session[:sort] = @sort
    session[:ratings] = @ratParam
    
    @checked_ratings = check_ratings
    
    @checked_ratings.each do |rating|
      params[rating] = true
    end
    #rating: session[:ratings]
    @movies = Movie.where(:rating => @checked_ratings).order(session[:sort])
    if(params[:sort].nil? and !(session[:sort].nil?)) or (params[:ratings].nil? and !(session[:ratings].nil?))
      flash.keep
      redirect_to movies_path(sort: session[:sort], ratings: session[:ratings])
    end
    
    #params[:ratings].nil? ? t_param = @all_ratings : t_param = params[:ratings].keys
    #@movies = Movie.where(rating: t_param).order(@sort)
    
  end

  def check_ratings
    if params[:ratings]
      params[:ratings].keys
    else
      @all_ratings
    end
  end


  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
