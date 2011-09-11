object Main extends App {
  import scala.io._
  private def parse_problem(s : Source) = {
    (try s.getLines.toList finally s.close).drop(2).map(_.split(","))
  }
  private def parse_answer(s : Source) = {
    try s.getLines.toList finally s.close
  }
  private def move(w : Int, h : Int, init : String, hands : String) : String = {
    if (0 == hands.length) {
      return "ok"
    }
    val hand = hands.head
    val last = hands.tail
    def found_zero(board : String) = {
      board.indexWhere('0'==_)
    }
    def swap(board : String, pos : Int, new_pos : Int) : Option[String] = {
      var new_board = new StringBuilder(board)
      var new_value = board(new_pos)
      if ('=' == new_value) {
        return None
      }
      new_board(new_pos) = board(pos)
      new_board(pos) = new_value
      Some(new_board.toString)
    }
    def next(init : String, step : Int, valid : (Int => Boolean)) : Option[String] = {
      val pos = found_zero(init)
      val new_pos = pos + step
      if (!valid(new_pos)) {
        return None
      }
      swap(init, pos, new_pos)
    }
    def nextAll(init :String, hand : Char) = {
      hand match {
        case 'U' => {
          val step = -w
          val valid = (x : Int) => !(x < 0)
          next(init, step, valid)
        }
        case 'D' => {
          val step = +w
          val valid = (x : Int) => x < init.length
          next(init, step, valid)
        }
        case 'R' => {
          val step = +1
          val valid = (x : Int) => !(x % w == 0)
          next(init, step, valid)
        }
        case 'L' => {
          val step = -1
          val valid = (x : Int) => !((x % w) == (w - 1))
          next(init, step, valid)
        }
        case _ => println("unknown hand: " + hand); None
      }
    }
    return nextAll(init, hand) match {
      case None => "not ok"
      case Some(b) => move(w, h, b, last)
    }
  }
  override def main(args : Array[String]) {
    val problem = parse_problem(Source.fromFile("input.txt"))
    val answer = parse_answer(Source.fromFile("output.txt"))
    println("1.." + problem.size)
    for (i <- 0 to problem.size - 1) {
      var buf = List((i + 1), problem(i).mkString(","))
      if (answer(i).length == 0) {
        buf ++= List("# TODO")
        buf = "not ok" :: buf
      } else {
        buf ++= List(answer(i))
        buf = move(problem(i)(0).toInt, problem(i)(1).toInt, problem(i)(2), answer(i)) :: buf
      }
      println(buf.mkString(" "))
    }
  }
}
