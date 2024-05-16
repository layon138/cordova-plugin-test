#!/usr/bin/python3

import sys
import logging

handlers = [logging.StreamHandler(sys.stdout)]

logging.basicConfig(
    level=logging.INFO,
    format='[%(asctime)-15s] [%(filename)-s:%(lineno)-d] %(levelname)-s - %(message)s',
    handlers=handlers
)

logger = logging.getLogger('md-deploy_mobile')


def shutdown():
    for handler in logger.handlers:
        handler.close()
        logger.removeFilter(handler)
