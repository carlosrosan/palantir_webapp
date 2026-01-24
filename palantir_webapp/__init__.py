# Use PyMySQL as MySQLdb (works on Windows without C compiler).
# Use 'python -m pip install <pkg>' to avoid broken pip launcher paths.
import pymysql
pymysql.install_as_MySQLdb()
