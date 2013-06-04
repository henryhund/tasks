require 'spec_helper'

describe "Tasks" do
  before do
    @task =  Task.create :task => 'go to bed'
    @task1 =  Task.create :task => 'wake up'
  end

  describe "GET /tasks" do
      it "display some tasks" do

        visit tasks_path
        page.should have_content 'go to bed'

      end

      it "creates a new task" do
        visit tasks_path
        fill_in 'Task', :with => 'go to work'
        click_button 'Create Task'

        current_path.should == tasks_path
        page.should have_content 'go to work'

        # save_and_open_page # opens page in browser in this state

      end
  end

  describe "PUT /tasks" do
    it "edits a task" do
      visit tasks_path
      find("#task_#{@task.id}").click_link 'Edit'

      current_path.should == edit_task_path(@task)

      #page.should have_content 'go to bed'
      find_field('Task').value.should == 'go to bed'

      fill_in 'Task', :with => 'updated task'
      click_button 'Update Task'

      current_path.should == tasks_path

      page.should have_content 'updated task'

    end

    it "should not update an empty task" do
      visit tasks_path
      find("#task_#{@task.id}").click_link 'Edit'

      fill_in 'Task', :with => ''
      click_button 'Update Task'

      current_path.should == edit_task_path(@task)
      page.should have_content 'There was an error updating your task.'

    end

  end

  describe "DELETE /tasks" do
    it "should delete a task" do
      visit tasks_path
      find("#task_#{@task.id}").click_link "Delete"
      page.should have_content 'Task has been deleted'
      page.should have_no_content 'go to bed'

    end
  end

  describe "SHOW /tasks" do
    it "should show individual task" do
      visit tasks_path
      click_link "#{@task.task}"
      page.should have_content 'go to bed'
      page.should have_no_content 'wake up'

    end
    it "should delete task from show page" do
      visit tasks_path
      click_link "#{@task.task}"
      page.should have_content 'go to bed'
      page.should have_no_content 'wake up'
      click_link "Delete"
      current_path.should == tasks_path
      page.should have_content 'wake up'
      page.should have_no_content 'go to bed'

    end

  end
end
