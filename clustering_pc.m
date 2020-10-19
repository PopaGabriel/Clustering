function [centroids] = clustering_pc(points, NC)
    [n, d] = size(points);
    %prealocare pentru rapiditate
    centroids=zeros(NC , d);
    clusters=zeros(NC,d);
    nrmembri=zeros(NC,1);
    centroizi_initial = zeros(NC,d);
    distanta = 0;
    %Valoare pentru verificare daca s-au miscat centroizii
    %Dupa o aplicare a algoritmului
    kounter = 1;
    
    %Initializarea lista de clustere
    for i = 1 : n
      k=mod(i,NC)+1;
      clusters(k,:) = clusters(k,:) + points(i,:);
      nrmembri(k) = nrmembri(k) + 1 ;
    end
    %Initializare centroizi initiali
    %Golire lista clustere
    for i = 1 : NC
      centroids(i,:)=clusters(i,:)/nrmembri(i);
      nrmembri(i)=0;
      clusters(i,:)=0;
    end
    centroizi_initial = centroids;
    
  while kounter == 1
    for i = 1 : n
        distanta_min=1000;
        %se calculeaza distanta minima de la un punct la unul dintre centroizi
        for k = 1 : NC
          distanta = sqrt(sum( (points(i,:)- centroids(k,:)).^2));  
        if distanta < distanta_min
            distanta_min = distanta;
            z = k;
        end
        end
        %Se adauga valorile coordonatelor punctului in cluster
        clusters(z,:)= clusters(z,:) + points(i,:);
        %Se mareste numarul de membrii din centroidul respectiv
        nrmembri(z) = nrmembri(z) + 1;
    end
      
    for i = 1 : NC
      %Daca clusterul nu contine membrii
      %Se alege un punct ales aleator care devine cluster
      if nrmembri(i) == 0
        clusters(i,:) = points( randperm(n,1),:);
        nrmembri(i) = nrmembri(i) + 1;
      end
      %Se calculeaza noua lista de centroizi
      centroids(i,:)=clusters(i,:)/nrmembri(i);
      nrmembri(i)=0;
      clusters(i,:)=0;
    end
    
    kounter = 0;
    for i = 1 : NC
      %Se verifica daca centroidul calculat este
      %Identic cu cel calculat anterior
      if centroids(i,:) ~= centroizi_initial(i,:)
        kounter = 1;
        centroizi_initial = centroids;
        break;
      end
    end
  end