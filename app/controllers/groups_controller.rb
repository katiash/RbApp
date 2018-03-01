class GroupsController < ApplicationController
  def index
    @groups = Group.all
    @group = Group.new
  end

  def create
    puts "In Groups Controller, 'group' create method"
    puts "params in 'new group' create method: #{params}"
    # puts "params[:group][:name]",params[:group][:description] 
    puts "Current user is: ", current_user

    @group = Group.new(user: current_user, name: params[:group][:name], description: params[:group][:description])
 
    puts "Group valid?", @group.valid?
    if @group.save
      puts "success for group.save"
      flash[:notice] = ["Group successfully created! You have been automatically added to members' list."]
      @membership = Membership.new(user_id: current_user.id, group: @group)
      puts @membership.valid?
      @membership.save
      redirect_to "/groups"
    else
      flash.now[:notice] = ["Group was not created. See errors below."]
      flash.now[:errors] = @group.errors.full_messages
      puts "Errors to display to client for new user create", @group.errors.full_messages
      puts "@group not saved, here is what was entered", @group.inspect
      @groups=Group.all
      render :action=> 'index'
    end
  end

  # delete "groups/:id" => "groups#destroy"
  def destroy
    puts "In groups destroy method: params are: ", params.inspect
    @group = Group.find(params[:id])
    puts "@group found in destroy method is: ", @group
    if current_user.id == @group.user.id
      puts "Current user is the Group Owner. Destroying group..."
      @group.destroy
      puts "@group after destroy: ", @group
      flash[:notice] = ["Group has been successfully deleted"]
      redirect_to "/groups"
    else
      flash[:notice] = ["Was not able to delete group."]
      # puts "Something went wrong in Group destroy"
      redirect_to "/groups"
    end
  end

  def show
    @group = Group.find(params[:id])
  end
end
