import os
import flask

from typing import Optional


class DatastoreViewer:
    def __init__(
            self,
            emulator_host: Optional[str] = None,
    ):
        if emulator_host is not None:
            os.environ['DATASTORE_EMULATOR_HOST'] = emulator_host

        if 'DATASTORE_EMULATOR_HOST' not in os.environ:
            raise RuntimeError(f'Environment variable "DATASTORE_EMULATOR_HOST" is required.')

        self._app = self._app_init()
        self._app_load()

    def _app_init(self):
        app = flask.Flask(__name__)
        app.config['JSON_AS_ASCII'] = False

        return app

    def _app_load(self):
        from datastore_viewer.presentation import blueprint

        self._app.register_blueprint(blueprint)

    def run(
            self,
            host: Optional[str] = None,
            port: Optional[str] = None,
            debug: Optional[bool] = None,
    ):
        return self._app.run(
            host=host,
            port=port,
            debug=debug,
        )


if __name__ == '__main__':
    DatastoreViewer().run(host='0.0.0.0', port='48080', debug=True)
