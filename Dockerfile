#set base image
FROM iron/ruby

#update packages
RUN apk update && apk upgrade

#add Nokogiri
RUN apk add ruby-nokogiri

#clear the cache
RUN rm -rf /var/cache/*

