FROM python:2.7.14-jessie

# Mono: 4.8.0.524

# The Mono Project doesn't publish Mono 4.x snapshots for Jessie. Instead, use
# Wheezy snapshots plus its "compat libraries" (dependencies not originally
# maintained by the Mono Project that were part of Wheezy but are not part of
# Jessie) instead.
# See https://stackoverflow.com/questions/29982959/how-to-install-mono-4-0-1-on-debian-8

# See https://bugzilla.xamarin.com/show_bug.cgi?id=24902 for why the "/." is
# included in the following statement.

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
  && echo "deb http://download.mono-project.com/repo/debian wheezy/snapshots/4.8.0.524/. main" > /etc/apt/sources.list.d/mono-official.list \
  && echo "deb http://download.mono-project.com/repo/debian wheezy-apache24-compat main" >> /etc/apt/sources.list.d/mono-official.list \
  && echo "deb http://download.mono-project.com/repo/debian wheezy-libjpeg62-compat main" >> /etc/apt/sources.list.d/mono-official.list \
  && apt-get update \
  && apt-get install -y clang \
  && apt-get install -y mono-complete=4.8.0.524\* \
  && rm -rf /var/lib/apt/lists/* /tmp/*


# RUN pip install pycparser pythonnet==2.4.0.dev0 (from Github)

# pythonnet 2.4.0 is still in development and not available on PyPI yet

RUN pip install pycparser \
  && git clone https://github.com/pythonnet/pythonnet \
  && python pythonnet/setup.py bdist_wheel \
  && pip install --no-index --find-links=./pythonnet/dist/ pythonnet

