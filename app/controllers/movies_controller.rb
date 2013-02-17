# in app/controllers/movies_controller.rb

class MoviesController < ApplicationController
  def index
#session stuff
  needredirect = false
  redirecthash = {}
    if !params.has_key?("ratings")
      if session.has_key?("ratings")
        needredirect = true
        redirecthash[:ratings] = session[:ratings]
      end
    else
      session[:ratings] = params[:ratings]
    end
    if !params.has_key?("sort") && !params.has_key?("current_sort")
      if session.has_key?("sort")
        needredirect = true
        redirecthash[:sort] = session[:sort]
      end
    else
      if params.has_key?("sort")
        session[:sort] = params[:sort]
      else
        session[:sort] = params[:current_sort]
      end
    end
#if should redirect, do it.
    if needredirect
      flash.keep
      redirect_to movies_path(redirecthash.merge(params))
    end
#take care of sorted stuff
    if params.has_key?("current_sort")
      srt = params[:current_sort].to_s
    else
      srt = params[:sort].to_s
    end
#take care of ratings stuff
    if !params.has_key?("ratings")
      crates = Movie.hratings
      rates = Movie.ratings
    else
      crates = params[:ratings]
      rates = params[:ratings].keys
    end
    if srt != "release_date" && srt != "title"
      srt = nil
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
