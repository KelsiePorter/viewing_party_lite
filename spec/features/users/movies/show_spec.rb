require 'rails_helper'

RSpec.describe 'Movie Details', type: :feature do
  
  let!(:user) { create(:user) }

  before :each do
    movie_id = 14

    @movie = MovieFacade.new(movie_id).movie
    visit user_movie_path(user, movie_id)
  end

  describe 'the movie show page' do
    describe 'navigation' do
      it 'has a button to create a viewing party' do
        click_button "Create Viewing Party for #{@movie.title}" 

        expect(current_path).to eq new_user_movie_viewing_party_path(user, @movie.id)
      end

      it 'has a button to return to the Discover Page' do
        expect(page).to have_button "Discover"
        click_button "Discover"

        expect(current_path).to eq discover_user_path(user)
      end
    end

    describe 'movie data' do
      it 'displays the movies title, vote_avg, runtime, genre, summary, and cast' do
        #TODO: this test is getting bloated, break up.

        within "#movie" do
          expect(page).to have_content "Movie Title: #{@movie.title}"
          expect(page).to have_content "Runtime: #{@movie.runtime}"
          expect(page).to have_content "Genre: #{@movie.genres}"
          expect(page).to have_content "Summary: #{@movie.overview}"

          @movie.cast.each do |cast_member|
            expect(page).to have_content cast_member
          end

          #expect(page).to have_content "Total Reviews: #{@movie.review_total}"
          #@movie.reviewers.each do |reviewer|
          #  expect(page).to have_content "Review Author: #{reviewer.author}"
          #  expect(page).to have_content "Author Information: #{reviewer.information}"
          #end
        end
      end
    end
  end
end

