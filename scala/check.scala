object Main extends App {
  import scala.io._
  private def parse_problem(s : Source) = {
    (try s.getLines.toList finally s.close).drop(2).map(_.split(","))
  }
  private def parse_answer(s : Source) = {
    try s.getLines.toList finally s.close
  }
  override def main(args : Array[String]) {
    val problem = parse_problem(Source.fromFile("input.txt"))
    val answer = parse_answer(Source.fromFile("output.txt"))
    for (i <- 0 to problem.size - 1) {
      var buf = List((i + 1), problem(i).mkString(","))
      if (answer(i).length == 0) {
        buf ++= List("skip")
      } else {
        buf ++= List(answer(i))
      }
      println(buf.mkString(" "))
    }
  }
}
