FROM python:3.5.5-jessie

# Mono: 5.4.1.6

# See https://bugzilla.xamarin.com/show_bug.cgi?id=24902 for why the "/." is
# included in the following statement.

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
  && echo "deb http://download.mono-project.com/repo/debian jessie/snapshots/5.4.1.6/. main" > /etc/apt/sources.list.d/mono-official.list \
  && apt-get update \
  && apt-get install -y clang \
  && apt-get install -y mono-complete=5.4.1.6\* \
  && rm -rf /var/lib/apt/lists/* /tmp/*


# RUN pip install pycparser pythonnet==2.4.0.dev0 (from Github)

# pythonnet 2.4.0 is still in development and not available on PyPI yet

RUN pip install pycparser \
  && git clone https://github.com/pythonnet/pythonnet \
  && python pythonnet/setup.py bdist_wheel \
  && pip install --no-index --find-links=./pythonnet/dist/ pythonnet

