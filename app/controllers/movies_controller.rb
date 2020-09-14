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
  
    @all_ratings = Movie.all_ratings
    
    
    # I would like to have the info from @ratings and @sort and then pass to @movies
    # first, I need to check if there is new update for them
    
    new_sort = params[:sort]
    new_ratings = params[:ratings]
    
    mem_sort = session[:sort]
    mem_ratings = session[:ratings]
    
    # if new exisit sth, means table should be renewed
    if new_sort or new_ratings
      @sort = new_sort
      @ratings = new_ratings
      session[:sort] = new_sort
      session[:ratings] = new_ratings
    
    # if no new, but mem, remain mem :sort and :ratings
    elsif mem_sort or mem_ratings
      @sort = mem_sort
      @ratings = mem_ratings
      flash.keep
      redirect_to movies_path(:sort => @sort, :ratings => @ratings)
    end
    
    # I don't want @ratings be null, I would like to checked all check box if user check nothing
    if @ratings == nil
      @ratings = Hash.new
      @all_ratings.each do |rating|
        @ratings[rating] = 1
      end
    end
    
    #Finally, give @ratings and @sort to  @movies
    @movies = Movie.where(:rating => @ratings.keys).order(@sort)
    
    
    #---------------------decide which item should be yellow back ground
    if params[:sort] == "title" then
      @title_header = "hilite"
    else
      @title_header = ""
    end
    
    
    if params[:sort] == "release_date" then
      @release_date_header = "hilite"
    else
      @release_date_header = ""
    end
    #---------------------decide which item should be yellow back ground
    
    
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
