import unittest
import tempfile
import os

from romidata import RomiTask, DatabaseConfig, FilesetTarget, FSDB
from romidata.task import FileByFileTask, FilesetExists, ImagesFilesetExists
from romidata.testing import TemporaryCloneDB, DBTestCase

import luigi
import numpy as np


class TouchFileTask(RomiTask):
    def requires(self):
        return[]
    def run(self):
        x = self.output().get()
        y = x.create_file("hello")
        y.write("hello", "txt")

class TestFilesetExists(FilesetExists):
    fileset_id = "testfileset"

class DoNothingTask(RomiTask):
    def requires(self):
        return TestFilesetExists()
    def run(self):
        pass

class ImageIdentityTask(FileByFileTask):
    type = "image"
    def f(self, x):
        return x

    def requires(self):
        return ImagesFilesetExists()



class TestFilesetTarget(DBTestCase):
    def test_target(self):
        db = self.get_test_db()
        target = FilesetTarget(db, "testscan", "test_target")
        assert(target.get(create=False) is None)
        assert(not target.exists())
        target.create()
        assert(target.exists())
        assert(target.get() is not None)

class TestRomiTask(DBTestCase):
    def test_romi_task(self):
        db = self.get_test_db()
        DatabaseConfig.db = db
        DatabaseConfig.scan_id = "testscan"
        task = TouchFileTask()
        assert(not task.complete())
        luigi.build(tasks=[task], local_scheduler=True)
        assert(task.complete())

class TestFileByFileTask(DBTestCase):
   def test_romi_task(self):
        db = self.get_test_db()
        DatabaseConfig.db = db
        DatabaseConfig.scan_id = "testscan"
        task = ImageIdentityTask()
        assert(not task.complete())
        luigi.build(tasks=[task], local_scheduler=True)
        assert(task.complete())

if __name__ == "__main__":
    unittest.main()



