class AnswersController < ApplicationController

    before_action :set_answer, only: [:destroy, :upvote, :downvote]

    def index
        @answers = Answer.all.order(:cached_votes_up => :desc)
    end

    def new
        @answer = Answer.new
    end

    def create
        @question = Question.find(params[:question_id])
        @answer = @question.answers.create(answer_params)
        redirect_to question_path(@question)
    end
    def destroy
        @question = Question.find(params[:question_id])
        @answer = @question.answers.find(params[:id])
        @answer.destroy
        redirect_to question_path(@question)
    end

    # Thumbs-up voting that is assigned to each user
    def upvote
        @answer.upvote_from current_user # a user cannot vote more than one time
        redirect_to request.referrer 
    end


    def downvote 
        @answer.downvote_from current_user
        if(answer_rejected?)
            @answer.destroy
            redirect_to request.referrer
        else
            redirect_to request.referrer
        end
    end

    private
        def answer_rejected?
            @total = @answer.cached_votes_total
            if(@total > 3 && @answer.cached_votes_down > 0.6 * @total)
                return true
            else
                return false
            end
                
        end

        def set_answer
            @answer = Answer.find(params[:id])
        end

        def answer_params
          params[:answer][:user_id] = current_user.id
          params.require(:answer).permit(:user_id, :body)
        end
end