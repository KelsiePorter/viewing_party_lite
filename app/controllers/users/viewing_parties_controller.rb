# frozen_string_literal: true

module Users
  class ViewingPartiesController < ApplicationController
    before_action :load_host
    before_action :load_movie
    before_action :validate_duration, only: [:create]
    before_action :authorize!

    def new
      @all_users = User.where.not(id: @host)
    end

    def create
      viewing_party = ViewingParty.new(viewing_party_params)

      if viewing_party.save
        viewing_party_user_ids.each do |user_id|
          viewing_party.users << User.find(user_id)
        end

        redirect_to user_path(@host.id)
      else
        redirect_to new_user_movie_viewing_party_path(@host.id, @movie.id)

        flash[:alert] = viewing_party.errors.full_messages.to_sentence
      end
    end

    private

    def load_host
      @host ||= User.find(params[:user_id])
    end

    def load_movie
      @movie ||= MovieFacade.new(params[:movie_id]).movie
    end

    def validate_duration
      return unless viewing_party_params[:duration].to_i < @movie.runtime

      flash[:alert] = "Viewing Party duration must be greater than or equal to movie runtime which is #{@movie.runtime}"
      redirect_to new_user_movie_viewing_party_path(@host.id, @movie.id)
    end

    def date
      "#{params['date(1i)']}/#{params['date(2i)']}/#{params['date(3i)']}"
    end

    def time
      "#{params['start_time(4i)']}:#{params['start_time(5i)']}:00"
    end

    def viewing_party_params
      params.permit(
        :duration,
        :host_id,
        :movie_id
      ).merge(
        date: date,
        start_time: "#{date} #{time}"
      )
    end

    def viewing_party_user_ids
      string_ids = params.permit(user_ids: [])[:user_ids]
      string_ids.shift
      string_ids.map(&:to_i)
    end

    def authorize! 
      unless current_user
        flash[:notice] = "You must be logged in to create a viewing party"
        # user story wants the vistor to be redirected to the movie show page
        # but ou have to be logged in as a user to see the movie show page (user_movie_path)
        redirect_to root_path
      end
    end
  end
end
