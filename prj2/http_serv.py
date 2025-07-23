from prometheus_client import start_http_server, Gauge
import os
import subprocess

#метрики 
host_type_metric = Gauge('host_type', 'Type of the host (1 - Physical, 2 - VM, 3 - Container)')

def detect_host_type():
    """Определение типа хоста: физический сервер, виртуальная машина или контейнер."""
    
    #контейнер
    try:
        with open('/proc/1/cgroup', 'rt') as f:
            if 'docker' in f.read() or os.path.exists('/.dockerenv'):
                return 3  
    except FileNotFoundError:
        pass

    # vm
    try:
        output = subprocess.check_output(['sudo', 'dmidecode', '-s', 'system-product-name']).decode().strip()
        if output in ['VirtualBox', 'KVM', 'VMware Virtual Platform', 'Microsoft Corporation Virtual Machine']:
            return 2  
    except Exception:
        pass

    try:
        with open('/sys/class/dmi/id/product_name') as f:
            product_name = f.read().strip()
            if product_name in ['VirtualBox', 'KVM', 'VMware Virtual Platform', 'Microsoft Corporation Virtual Machine']:
                return 2  
    except FileNotFoundError:
        pass

    
    try:
        with open('/proc/cpuinfo', 'r') as f:
            if 'hypervisor' in f.read():
                return 2  
    except Exception:
        pass

    return 1 
def main():
    
    host_type = detect_host_type()
    host_type_metric.set(host_type)

  
    start_http_server(8080, addr="0.0.0.0")
    print("HTTP сервер запущен на порту 8080. Экспорт метрик доступен по адресу http://localhost:8080/metrics.")

    
    while True:
        pass

if __name__ == '__main__':
    main()
