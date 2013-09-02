class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!, except: [:tag_count, :tag_count_post]

  def tag_count
    @tag_count_user = User.tag_counts_on(:investment_styles).map {|tag| {text: tag.name, weight: tag.count}}

    render json: @tag_count_user
  end

  def tag_count_post
    @tag_count_post = Post.tag_counts_on(:tags).map {|tag| {text: tag.name, weight: tag.count}}
    @tags = [
      {text: "One", weight: 1},
      {text: "Two", weight: 2},
      {text: "Three", weight: 3},
      {text: "Four", weight: 4},
      {text: "Five", weight: 5},
      {text: "Six", weight: 6},
      {text: "Seven", weight: 7},
      {text: "Eight", weight: 8},
      {text: "Nine", weight: 9},
      {text: "Ten", weight: 10},
      {text: "One1", weight: 1},
      {text: "Two1", weight: 2},
      {text: "Three1", weight: 3},
      {text: "Four1", weight: 4},
      {text: "Five1", weight: 5},
      {text: "Six1", weight: 6},
      {text: "Seven1", weight: 7},
      {text: "Eight1", weight: 8},
      {text: "Nine1", weight: 9},
      {text: "Ten1", weight: 10},
      {text: "One2", weight: 1},
      {text: "Two2", weight: 2},
      {text: "Three2", weight: 3},
      {text: "Four2", weight: 4},
      {text: "Five2", weight: 5},
      {text: "Six2", weight: 6},
      {text: "Seven2", weight: 7},
      {text: "Eight2", weight: 8},
      {text: "Nine2", weight: 9},
      {text: "Ten2", weight: 10},
      {text: "One11", weight: 1},
      {text: "Two11", weight: 2},
      {text: "Three11", weight: 3},
      {text: "Four11", weight: 4},
      {text: "Five11", weight: 5},
      {text: "Six11", weight: 6},
      {text: "Seven11", weight: 7},
      {text: "Eight11", weight: 8},
      {text: "Nine11", weight: 9},
      {text: "Ten11", weight: 10},
         {text: "One3", weight: 1},
      {text: "Two3", weight: 2},
      {text: "Three3", weight: 3},
      {text: "Four3", weight: 4},
      {text: "Five3", weight: 5},
      {text: "Six3", weight: 6},
      {text: "Seven3", weight: 7},
      {text: "Eight3", weight: 8},
      {text: "Nine3", weight: 9},
      {text: "Ten3", weight: 10},
      {text: "One13", weight: 1},
      {text: "Two13", weight: 2},
      {text: "Three13", weight: 3},
      {text: "Four31", weight: 4},
      {text: "Five31", weight: 5},
      {text: "Six13", weight: 6},
      {text: "Seve3n1", weight: 7},
      {text: "Eigh3t1", weight: 8},
      {text: "Nine31", weight: 9},
      {text: "Ten31", weight: 10},
      {text: "One32", weight: 1},
      {text: "Two32", weight: 2},
      {text: "Thre3e2", weight: 3},
      {text: "Four32", weight: 4},
      {text: "Five2", weight: 5},
      {text: "Six23", weight: 6},
      {text: "Seven2", weight: 7},
      {text: "Eigh3t2", weight: 8},
      {text: "Nine32", weight: 9},
      {text: "Ten2", weight: 10},
      {text: "On3e11", weight: 1},
      {text: "Two11", weight: 2},
      {text: "Th3ree11", weight: 3},
      {text: "Four11", weight: 4},
      {text: "Fi3ve11", weight: 5},
      {text: "Six311", weight: 6},
      {text: "Seve3n11", weight: 7},
      {text: "Eight3311", weight: 8},
      {text: "Nine11", weight: 9},
      {text: "Ten11", weight: 10},
    ]
    render json: @tags
  end

end

