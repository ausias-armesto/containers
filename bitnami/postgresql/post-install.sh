#!/bin/bash
cd $BITNAMI_APP_DIR

# set up default configs
mkdir conf.defaults
s6-setuidgid $BITNAMI_APP_USER $BITNAMI_APP_DIR/bin/initdb -D $BITNAMI_APP_DIR/data \
  -U $BITNAMI_APP_USER -E unicode -A trust >/dev/null
mv $BITNAMI_APP_DIR/data/postgresql.conf conf.defaults/
mv $BITNAMI_APP_DIR/data/pg_hba.conf conf.defaults/
mv $BITNAMI_APP_DIR/data/pg_ident.conf conf.defaults/
rm -rf $BITNAMI_APP_DIR/data

sed -i "s|^[#]*[ ]*listen_addresses = .*|listen_addresses = '*'|" $BITNAMI_APP_DIR/conf.defaults/postgresql.conf
sed -i "s|^[#]*[ ]*logging_collector = .*|logging_collector = on|" $BITNAMI_APP_DIR/conf.defaults/postgresql.conf
sed -i "s|^[#]*[ ]*log_directory = .*|log_directory = '$BITNAMI_APP_DIR/logs'|" $BITNAMI_APP_DIR/conf.defaults/postgresql.conf
sed -i "s|^[#]*[ ]*log_filename = .*|log_filename = 'postgresql.log'|" $BITNAMI_APP_DIR/conf.defaults/postgresql.conf

cat >> $BITNAMI_APP_DIR/conf.defaults/pg_hba.conf <<EOF
host    all             all             0.0.0.0/0               md5
EOF

# symlink mount points at root to install dir
ln -s $BITNAMI_APP_DIR/data $BITNAMI_APP_VOL_PREFIX/data
ln -s $BITNAMI_APP_DIR/logs $BITNAMI_APP_VOL_PREFIX/logs
ln -s $BITNAMI_APP_DIR/conf $BITNAMI_APP_VOL_PREFIX/conf
