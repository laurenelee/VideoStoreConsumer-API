class MoviesController < ApplicationController
  before_action :require_movie, only: [:show]

  def index
    if params[:query]
      query = params[:query]
      # data = MovieWrapper.search(params[:query])
      data = Movie.all.select{ |movie| p movie; movie.title.include?query }
      p data
    else
      data = Movie.all
    end

    render status: :ok, json: data
  end

  def ok
    render status: :ok
  end

  def show
    render(
      status: :ok,
      json: @movie.as_json(
        only: [:title, :overview, :release_date, :inventory],
        methods: [:available_inventory]
        )
      )
  end

  def create
    movie_data = movie_params(params)
    movie = Movie.new(movie_data)
    movie.save

    render status: :ok, json: {title: movie.title}
  end

  private

  def require_movie
    @movie = Movie.find_by(title: params[:title])
    unless @movie
      render status: :not_found, json: { errors: { title: ["No movie with title #{params["title"]}"] } }
    end
  end

  def movie_params(params)
    return params.permit(:title, :overview, :release_date, :inventory, :image_url)
  end
end
