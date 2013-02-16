# in app/controllers/movies_controller.rb

class MoviesController < ApplicationController
  def index
    if params.has_key?("current_sort")
      srt = params[:current_sort].to_s
    else
      srt = params[:sort].to_s
    end
#take care of sorted stuff
    if srt != "release_date" && srt != "title"
      srt = nil
    end
#take care of ratings stuff
    if !params.has_key?("ratings")
      crates = Movie.hratings
      rates = Movie.ratings
    else
      crates = params[:ratings]
      rates = params[:ratings].keys
    end
#make our query
    @movies = Movie.where(:rating => rates).order(srt)
#set other stuff
    @all_ratings = Movie.ratings  
    @highlight = srt
    @current_sort = srt
    @current_ratings = crates
  end

  def show
    id = params[:id]
    @movie = Movie.find(id)
    # will render app/views/movies/show.html.haml by default
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
