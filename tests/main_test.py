import pydoro.main


def test_app_status():
    assert pydoro.main.app_status() == 'ok'
