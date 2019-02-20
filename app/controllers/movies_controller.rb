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
      @movies = Movie.all
      @all_ratings = Movie.all_ratings
      redirect = false
      
      
      if params[:sort]
          @sort = params[:sort]
          session[:sort] = params[:sort]
          #@movies = Movie.sort_on(@sort, @movies)
      elsif session[:sort]
          flash.keep
          @sort = session[:sort]
          redirect = true
      end
      
      
      if params[:ratings]
          @rating = params[:ratings]
          session[:ratings] = params[:ratings]
          #@movies = Movie.ratings_filter(@rating)
      elsif session[:ratings]
          flash.keep
          @rating = session[:ratings]
          redirect = true
      else
          @rating = @all_ratings
      end
      
      if redirect
          redirect_to movies_path(sort: @sort, ratings: @rating)
      end
      
     if params[:ratings] and params[:sort]
          @movies = Movie.ratings_filter(@rating)
          @movies = Movie.sort_on(@sort, @movies)
      elsif @rating
          @movies = Movie.ratings_filter(@rating)
      elsif @sort
          @movies = Movie.sort_on(@sort, @movies)
      else
          @movies = Movie.all
      end
      
      if @sort == 'title'
         @title_highlight = 'hilite'
      elsif @sort == 'release_date'
         @release_date_highlight = 'hilite'
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
