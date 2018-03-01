class MembershipsController < ApplicationController
  # post "memberships" => "memberships#create"
  def create
    puts "params passed are: ", params.inspect
    # if current_user == @group.user
    @membership = Membership.new(user: current_user, group_id: params[:group])
    puts @membershp.inspect
    puts @membership.valid?
    @group = Group.find(params[:group])
    if @membership.save
      puts "You seems to have joined"
      redirect_to "/groups/#{@group.id}", notice: ["Successfully joined this group!"]
    else
      flash[:errors]=["Something went wrong and we could not place you in the group. Please try again."]
      puts "something went wrong on Join action"
      redirect_to "/groups/#{@group.id}" 
    end
  end

  # delete "memberships" => "memberships#destroy"
  def destroy
    puts "Got to Leave Group method"
    puts "our params are: ", params.inspect
    @membership = Membership.where("user_id = ? AND group_id = ?", current_user, params[:group])
    puts "Got our Membership to destroy: ", @membership.inspect
    if @membership[0].destroy
      flash[:notice]=["You have successfully left this group!"]
      puts "Seems to have destroyed membership", @membership
      redirect_to "/groups/#{params[:group]}"
    else
      flash[:errors]=["Something went wrong!"]
      puts "Something went wrong with Membership destroy attempt"
      redirect_to "/groups/#{params[:group]}"
    end
  end
end
