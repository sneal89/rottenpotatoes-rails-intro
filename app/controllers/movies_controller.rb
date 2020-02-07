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
    if params[:sort].nil? && params[:ratings].nil? && (!session[:sort].nil? || !session[:ratings].nil?)
      redirect_to movies_path(:sort => session[:sort], :ratings => session[:ratings])
    end
    
    #@ratings = params[:ratings]
    #if @ratings.nil?
    #  ratings = params[:sort]
    #else
    #  ratings = @ratings.keys
    #end
    
    @sort = params[:sort]
    @movies = Movie.all.order(@sort)
    @all_ratings = Movie.order(:rating).select(:rating).map(&:rating).uniq
    @checked_ratings = check_ratings
    @checked_ratings.each do |rating|
      params[rating] = true
    end
    
    if !@sort.nil?
      begin
        @movies = Movie.order("#{@sort} ASC ").find_all_by_rating(ratings)
      rescue ActiveRecord::StatementInvalid
      end
    else
        @movies = Movie.find_all_by_rating(ratings)
    end

    if params[:sort]
      @movies = Movie.order(params[:sort])
    else
      @movies = Movie.where(:rating => @checked_ratings)
    end
    
    session[:sort] = @sort
    session[:ratings] = @checked_ratings

   
  
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
