require "rails_helper"

RSpec.describe ExerciseTrackingsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/exercise_trackings").to route_to("exercise_trackings#index")
    end

    it "routes to #new" do
      expect(get: "/exercise_trackings/new").to route_to("exercise_trackings#new")
    end

    it "routes to #show" do
      expect(get: "/exercise_trackings/1").to route_to("exercise_trackings#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/exercise_trackings/1/edit").to route_to("exercise_trackings#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/exercise_trackings").to route_to("exercise_trackings#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/exercise_trackings/1").to route_to("exercise_trackings#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/exercise_trackings/1").to route_to("exercise_trackings#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/exercise_trackings/1").to route_to("exercise_trackings#destroy", id: "1")
    end
  end
end
