class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def move
    ActionController::Parameters.permit_all_parameters = true

    row = real_params[:row].to_i
    column = real_params[:column].to_i
    board = JSON.parse(real_params[:board].as_json)


    if board[row][column].blank?
      board[row][column] = 'O'

      board = do_computer_move(board)

      winner = determine_winner(board)
    end

    render json: { move: { board: board, winner: winner } }
  end

  def do_computer_move(board)
    3.times.each do |row|
      3.times.each do |column|
        if board[row][column].blank?
          board[row][column] = 'X'
          return board
        end
      end
    end
    board
  end

  def determine_winner(board)
    3.times.each do |x|
      if board[x][0] == board[x][1] && board[x][0] == board[x][2]
        return board[x][0]
      end
    end

    3.times.each do |y|
      if board[0][y] == board[1][y] && board[0][y] == board[2][y]
        return board[0][y]
      end
    end

    if board[0][0] == board[1][1] && board[0][0] == board[2][2]
      return board[0][0]
    end

    if board[0][2] == board[1][1] && board[0][2] == boaad[2][0]
      return board[0][2]
    end
  end

  def real_params
    params.require(:move).permit(:row, :column, :board)
  end
end
